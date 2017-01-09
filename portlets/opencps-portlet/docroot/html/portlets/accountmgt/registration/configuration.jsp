<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Layout"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%
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
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
%>
<%@ include file="../init.jsp"%>

<liferay-portlet:actionURL var="configurationURL" portletConfiguration="true" />
<liferay-ui:success key="config-stored" message="config-stored" />

<aui:form action="<%= configurationURL.toString() %>" method="post" name="fm">
    <aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	
	<aui:row>
		<aui:col width="30">
			<aui:select name="businessRegStep" label="config-businessRegStep">
		
				<aui:option selected="<%= businessRegStep_cfg.equals(\"3\") %>" value="3">3</aui:option>
				<aui:option selected="<%= businessRegStep_cfg.equals(\"2\") %>" value="2">2</aui:option>
				
			</aui:select>
		</aui:col>
		<aui:col width="30">
			<aui:select name="citizenRegStep" label="config-citizenRegStep">
			
				<aui:option selected="<%= citizenRegStep_cfg.equals(\"3\") %>" value="3">3</aui:option>
				<aui:option selected="<%= citizenRegStep_cfg.equals(\"2\") %>" value="2">2</aui:option>
				
			</aui:select>
		</aui:col>
		<aui:col width="40">
            <aui:select name="siteConfig" label="Site config">
                <%
                    for(Group site : sites) {
                %>
                        <aui:option value="<%=site.getGroupId()%>"><%=site.getName()%></aui:option>
                <%
                    }
                %>
            </aui:select>
        </aui:col>
	</aui:row>
	
	
    <aui:input name="action" type="hidden" id="action"></aui:input>
    <aui:button-row>
        <aui:button type="button" id="save" name="save" value="save" />  
    </aui:button-row>
</aui:form>

<aui:script>
	AUI().ready(function(A) {
		var btnSave = A.one('#<portlet:namespace />save');
		
		if(btnSave) {
			btnSave.on('click',function() {
				A.one('#<portlet:namespace />action').set('value', 'save');
				document.getElementById('<portlet:namespace />fm').submit();
			});
		}
	});
</aui:script>
