/**
* OpenCPS is the open source Core Public Services software
* Copyright (C) 2016-present OpenCPS community

* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU Affero General Public License for more details.
* You should have received a copy of the GNU Affero General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
*/
/**
 * 
 */
package org.opencps.servicemgt.portlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.portlet.ConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;


/**
 * @author dunglt
 *
 */
public class ConfigurationDisrectoryImpl implements ConfigurationAction{

	/* (non-Javadoc)
	 * @see com.liferay.portal.kernel.portlet.ConfigurationAction#processAction(javax.portlet.PortletConfig, javax.portlet.ActionRequest, javax.portlet.ActionResponse)
	 */
	@Override
	public void processAction(
		PortletConfig arg0, ActionRequest actionRequest, ActionResponse actionResponse)
		throws Exception {

		long plidServiceDetail = ParamUtil.getLong(actionRequest, "plidServiceDetail");
		String portletResource =
					    ParamUtil.getString(actionRequest, "portletResource");
		
		PortletPreferences preferences =
					    PortletPreferencesFactoryUtil.getPortletSetup(
					        actionRequest, portletResource);
		
		preferences.setValue("plidServiceDetail", String.valueOf(plidServiceDetail));
		preferences.store();
		
		SessionMessages.add(actionRequest, "potlet-config-saved");
	}

	/* (non-Javadoc)
	 * @see com.liferay.portal.kernel.portlet.ConfigurationAction#render(javax.portlet.PortletConfig, javax.portlet.RenderRequest, javax.portlet.RenderResponse)
	 */
	@Override
	public String render(
		PortletConfig arg0, RenderRequest arg1, RenderResponse arg2)
		throws Exception {

		return "/html/portlets/servicemgt/directory/configuration.jsp";
	}

}
