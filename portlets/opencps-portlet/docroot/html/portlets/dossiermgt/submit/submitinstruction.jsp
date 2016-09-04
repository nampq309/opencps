<%@page import="org.opencps.util.PortletPropsValues"%>
<%@page import="org.opencps.util.PortletUtil"%>
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
<%@ include file="init.jsp"%>
<%@page import="org.opencps.dossiermgt.service.ServiceConfigLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>
<%@page import="org.opencps.util.DictItemUtil"%>
<%@page import="org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="org.opencps.servicemgt.model.ServiceInfo"%>
<%@page import="java.util.List"%>
<%@page import="org.opencps.datamgt.service.DictItemLocalServiceUtil"%>
<liferay-util:include page='<%= templatePath + "toolbar.jsp"%>' servletContext="<%=application %>" />
<%
	String administrationCode = ParamUtil.getString(request, "administrationCode");

	String domainCode = ParamUtil.getString(request, "domainCode");


	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", templatePath + "submitinstruction.jsp");
	iteratorURL.setParameter("administrationCode", administrationCode);
	iteratorURL.setParameter("domainCode", domainCode);
	
	List<ServiceInfo> serviceInfos = new ArrayList<ServiceInfo>();
	List<ServiceConfig> serviceConfigs = new ArrayList<ServiceConfig>();	

	List<ServiceInfo> serviceInfoUses = new ArrayList<ServiceInfo>();
	int totalCount = 0;
	
	DictItem dictItemGov = null;
	
	try {
		dictItemGov = DictItemLocalServiceUtil.getDictItem(Long.valueOf(administrationCode));
	} catch(Exception e) {
		
	}
	String govCode = Validator.isNotNull(dictItemGov) ? dictItemGov.getItemCode() : StringPool.BLANK;	
	List<String> headerNames = new ArrayList<String>();
	
	headerNames.add("col1");
	headerNames.add("col2");
	headerNames.add("col3");
	headerNames.add("col4");
	
	String headers = StringUtil.merge(headerNames, StringPool.COMMA);
%>
<div class="opencps-searchcontainer-wrapper">
	<liferay-ui:search-container 
			emptyResultsMessage="no-serviceinfo-were-found"
			iteratorURL="<%=iteratorURL %>"
			delta="<%=20 %>"
			deltaConfigurable="true"
		>
		
		<liferay-ui:search-container-results>
			<%
				serviceConfigs = ServiceConfigLocalServiceUtil.searchServiceConfig(scopeGroupId, keyword, govCode, domainCode, searchContainer.getStart(), searchContainer.getEnd());
// 				(scopeGroupId, keyword,
// 					administrationCode, domainCode, 
// 					searchContainer.getStart(), searchContainer.getEnd());
				if(serviceConfigs!=null){
				}
				totalCount = ServiceConfigLocalServiceUtil.countServiceConfig(scopeGroupId, keyword, govCode, domainCode);
				results = serviceConfigs;
				total = totalCount;
				pageContext.setAttribute("results", results);
				pageContext.setAttribute("total", total);
			%>
		</liferay-ui:search-container-results>
		
		<liferay-ui:search-container-row 
			className="org.opencps.dossiermgt.model.ServiceConfig" 
			modelVar="service" 
			keyProperty="serviceConfigId"
		>
			<% 
				int level = 0;
				String serviceName = StringPool.BLANK;
				String itemName  = StringPool.BLANK;
				ServiceInfo serviceInfo = ServiceInfoLocalServiceUtil.getServiceInfo(service.getServiceInfoId());
				if(serviceInfo!=null){
					serviceName = serviceInfo.getServiceName();
				}
				itemName = service.getGovAgencyName();
			
			%>
			
			<liferay-util:buffer var="boundcol1">
				<div class="row-fluid">
				
					<div class="span12"><%=serviceName%></div>
				</div>
			</liferay-util:buffer>
			
			<liferay-util:buffer var="boundcol2">	
				<div class="row-fluid">
					
					<div class="span5 bold-label">
						<liferay-ui:message key="service-domain"/>
					</div>
					<div class="span7"><%=DictItemUtil.getNameDictItem(service.getDomainCode())%></div>
				</div>
				
				<div class="row-fluid">
					
					<div class="span5 bold-label">
						<liferay-ui:message key="service-administrator"/>
					</div>
					<div class="span7"><%=itemName%></div>
				</div>
				
				<div class="row-fluid">
					
					<div class="span5 bold-label">
						<liferay-ui:message key="level-dvc"/>
					</div>
					<div class="span7"><%=service.getServiceLevel() %> </div>
				</div>
			</liferay-util:buffer>
			
			<%
				row.setClassName("opencps-searchcontainer-row");
				row.addText(String.valueOf(row.getPos() + 1));
				row.addText(boundcol1);
				row.addText(boundcol2);
				row.addJSP("center", SearchEntry.DEFAULT_VALIGN,"/html/portlets/dossiermgt/submit/submit_action.jsp", config.getServletContext(), request, response);
			%>
				
		</liferay-ui:search-container-row>
			
		<liferay-ui:search-iterator type="opencs_page_iterator"/>
	
	</liferay-ui:search-container>
</div>