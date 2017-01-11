/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */

package org.opencps.backend.sync;

import java.util.List;

import org.opencps.backend.message.SendToBackOfficeMsg;
import org.opencps.backend.message.SendToCallbackMsg;
import org.opencps.dossiermgt.service.DossierLocalServiceUtil;
import org.opencps.processmgt.model.WorkflowOutput;
import org.opencps.processmgt.service.WorkflowOutputLocalServiceUtil;
import org.opencps.util.PortletConstants;
import org.opencps.util.WebKeys;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.messaging.Message;
import com.liferay.portal.kernel.messaging.MessageBusUtil;
import com.liferay.portal.kernel.messaging.MessageListener;
import com.liferay.portal.kernel.messaging.MessageListenerException;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.User;
import com.liferay.portal.service.UserLocalServiceUtil;


/**
 * @author khoavd
 *
 */
public class SyncFromBackOffice implements MessageListener{

	/* (non-Javadoc)
     * @see com.liferay.portal.kernel.messaging.MessageListener#receive(com.liferay.portal.kernel.messaging.Message)
     */
    @Override
    public void receive(Message message)
        throws MessageListenerException {
    	
    	_doRecevie(message);

    }
    
    
	private void _doRecevie(Message message) {

		SendToBackOfficeMsg toBackOffice =
		    (SendToBackOfficeMsg) message.get("toBackOffice");

		boolean statusUpdate = false;

		String actor = _getActor(toBackOffice.getUserActorAction());

		try {
			statusUpdate =
			    DossierLocalServiceUtil.updateDossierStatus(
			        toBackOffice.getDossierId(), toBackOffice.getFileGroupId(),
			        toBackOffice.getDossierStatus(),
			        toBackOffice.getReceptionNo(),
			        toBackOffice.getSubmitDateTime(),
			        toBackOffice.getEstimateDatetime(),
			        toBackOffice.getReceiveDatetime(),
			        toBackOffice.getFinishDatetime(), actor,
			        toBackOffice.getRequestCommand(),
			        toBackOffice.getActionInfo(), toBackOffice.getMessageInfo());

			List<WorkflowOutput> workflowOutputs =
			    WorkflowOutputLocalServiceUtil.getByProcessWFPostback(toBackOffice.getProcessWorkflowId(), true);

			DossierLocalServiceUtil.updateDossierStatus(
			    0, toBackOffice.getDossierId(),
			    PortletConstants.DOSSIER_FILE_SYNC_STATUS_SYNCSUCCESS,
			    workflowOutputs);
		}
		catch (Exception e) {
			_log.error(e);
		}

		SendToCallbackMsg toCallBack = new SendToCallbackMsg();

		toCallBack.setProcessOrderId(toBackOffice.getProcessOrderId());
		toCallBack.setSyncStatus(statusUpdate ? "ok" : "error");
		toCallBack.setDossierStatus(toBackOffice.getDossierStatus());
		Message sendToCallBack = new Message();

		sendToCallBack.put("toCallback", toCallBack);

		MessageBusUtil.sendMessage(
		    "opencps/backoffice/engine/callback", sendToCallBack);
	}    
    

    /**
     * @param userActionId
     * @return
     */
    private String _getActor(long userActionId) {
    	String actor = StringPool.BLANK;
    	
    	try {
        	if (Validator.isNotNull(userActionId) && userActionId > 0) {
        		User userActor = UserLocalServiceUtil.fetchUser(userActionId);
        		
        		actor = "[CB]" + StringPool.SPACE + userActor.getFullName();
        	}
        }
        catch (Exception e) {
	        actor = "system";
        }
    	
    	return actor;
    }
    
    private Log _log = LogFactoryUtil.getLog(SyncFromBackOffice.class);

}
