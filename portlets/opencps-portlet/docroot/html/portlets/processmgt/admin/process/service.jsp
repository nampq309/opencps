
<%@page import="com.liferay.portal.kernel.language.UnicodeLanguageUtil"%>
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
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */
%>
<%@page import="org.opencps.util.PortletPropsValues"%>
<%@page import="org.opencps.util.PortletUtil"%>
<%@page import="org.opencps.datamgt.service.DictItemLocalServiceUtil"%>
<%@page import="org.opencps.datamgt.model.DictItem"%>
<%@page import="org.opencps.dossiermgt.service.ServiceConfigLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>
<%@page import="org.opencps.util.DictItemUtil"%>
<%@page import="org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil"%>
<%@page import="org.opencps.processmgt.service.ServiceInfoProcessLocalServiceUtil"%>
<%@page import="org.opencps.processmgt.model.ServiceInfoProcess"%>

<%@ include file="../../init.jsp" %>


<%
	ServiceProcess serviceProcess = (ServiceProcess) request.getAttribute(WebKeys.SERVICE_PROCESS_ENTRY);
	
	long serviceProcessId = Validator.isNotNull(serviceProcess) ? serviceProcess.getServiceProcessId() : 0L;
	
	List<ServiceConfig> serviceConfigs = new ArrayList<ServiceConfig>();
	List<ServiceInfoProcess> serviceInfoProcesses = new ArrayList<ServiceInfoProcess>();
	
	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", templatePath +
		"process/service.jsp");
	
	try {
		serviceInfoProcesses = ServiceInfoProcessLocalServiceUtil.getServiceInfoProcessByProcessId(serviceProcessId);
		
	} catch (Exception e) {
		
	}
	
	try {
		for(ServiceInfoProcess serviceInfoProcess : serviceInfoProcesses) {
			serviceConfigs.add(ServiceConfigLocalServiceUtil.getServiceConfig(serviceInfoProcess.getServiceinfoId()));
		}
	} catch (Exception e) {
		
	}
	
%>

<portlet:renderURL var="chooseServiceURL" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
	<portlet:param name="serviceProcessId" value="<%=String.valueOf(serviceProcessId) %>"/>
	<portlet:param name="backURL" value="<%=currentURL %>"/>
	<portlet:param name="mvcPath" value='<%=templatePath + "choose_service.jsp" %>'/>
</portlet:renderURL>

<aui:button name="chooseService" value="choose-service" cssClass="mg-b-20"/>


<liferay-ui:search-container 
		emptyResultsMessage="no-service-were-found"
		iteratorURL="<%=iteratorURL %>"
		delta="<%=serviceConfigs.size() %>"
		deltaConfigurable="true"
>
	<liferay-ui:search-container-results>
		<%
		results = serviceConfigs;
		total = serviceConfigs.size();
		pageContext.setAttribute("results", results);
		pageContext.setAttribute("total", total);
		%>
	</liferay-ui:search-container-results>
	
	<liferay-ui:search-container-row 
		className="org.opencps.dossiermgt.model.ServiceConfig" 
		modelVar="serviceConfig" 
		keyProperty="serviceConfigId"
	>
		<%
			ServiceInfo service = null;
			long serviceId = 0;
			
			DictItem dictItem = null;
			
			DictItem adminAction = PortletUtil.getDictItem(PortletPropsValues.DATAMGT_MASTERDATA_GOVERNMENT_AGENCY, serviceConfig.getGovAgencyCode(), scopeGroupId);
			String administrationName = StringPool.BLANK;
			try {
				service = ServiceInfoLocalServiceUtil.getServiceInfo(serviceConfig.getServiceInfoId());
				serviceId = service.getServiceinfoId();
			} catch(Exception e) {
				
			}
			
			try {
				dictItem = DictItemLocalServiceUtil.getDicItemByTreeIndex(serviceConfig.getServiceDomainIndex());
				administrationName = dictItem.getItemName(themeDisplay.getLocale(),true);
			
			} catch (Exception e) {
				
			}
		%>
	
		<portlet:actionURL var="deteleRelaSeInfoAndProcessURL" name="deteleRelaSeInfoAndProcess" >
			<portlet:param name="serviceProcessId" value="<%=String.valueOf(serviceProcessId) %>"/>
			<portlet:param name="serviceConfigId" value="<%=String.valueOf(serviceConfig.getServiceConfigId()) %>"/>
			<portlet:param name="backURL" value="<%=currentURL %>"/>
		</portlet:actionURL>
		
		<liferay-ui:search-container-column-text 
				name="row-index" value="<%= String.valueOf(row.getPos() +1 ) %>"
			/>
		<liferay-ui:search-container-column-text 
				name="service-name" value="<%=service.getServiceName() %>"
			/>
		<liferay-ui:search-container-column-text 
				name="service-domain" value="<%=DictItemUtil.getNameDictItem(service.getDomainCode()) %>"
			/>
		<liferay-ui:search-container-column-text 
				name="service-administration-action" 
				value="<%=Validator.isNotNull(adminAction) ? adminAction.getItemName(locale,true) : StringPool.BLANK %>"
			/>
		<%
			 final String hrefFix = "location.href='" + deteleRelaSeInfoAndProcessURL .toString()+"'";
		%>
			
		<liferay-ui:search-container-column-button
			href="<%= hrefFix %>" 
			name="delete" 
		/>
	</liferay-ui:search-container-row>
	<liferay-ui:search-iterator paginate="false"/>
</liferay-ui:search-container>

<aui:script use="liferay-util-window">
	A.one('#<portlet:namespace/>chooseService').on('click', function(event) {
		
		openDialog('<%=chooseServiceURL %>', '<portlet:namespace/>chooseService' , '<%=UnicodeLanguageUtil.get(pageContext, "choose-service")%>');
		
	});
</aui:script>

