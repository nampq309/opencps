<%@page import="org.opencps.dossiermgt.search.DossierDisplayTerms"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="org.opencps.processmgt.util.ProcessOrderUtils"%>
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

<%@page import="com.liferay.portal.kernel.dao.search.SearchEntry"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="org.opencps.datamgt.model.DictItem"%>
<%@page import="org.opencps.datamgt.service.DictItemLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.bean.ServiceBean"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>
<%@page import="org.opencps.dossiermgt.search.ServiceSearch"%>
<%@page import="org.opencps.dossiermgt.search.ServiceSearchTerms"%>
<%@page import="org.opencps.dossiermgt.service.ServiceConfigLocalServiceUtil"%>
<%@page import="org.opencps.servicemgt.model.ServiceInfo"%>
<%@page import="org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil"%>
<%@page import="org.opencps.servicemgt.util.ServiceUtil"%>
<%@page import="org.opencps.util.PortletConstants"%>

<%@ include file="../../init.jsp"%>

<%
	String serviceDomainIdCHKInit = ParamUtil.getString(request, "serviceDomainId", "-1");

	long serviceDomainId = ParamUtil.getLong(request, "serviceDomainId");
	
	long govAgencyId = ParamUtil.getLong(request, "govAgencyId");

	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", templatePath + "frontofficeservicelist.jsp");
	iteratorURL.setParameter("isListServiceConfig", String.valueOf(true));
	iteratorURL.setParameter("govAgencyId", (govAgencyId > 0) ? String.valueOf(govAgencyId):StringPool.BLANK);
	iteratorURL.setParameter("serviceDomainId", (serviceDomainId > 0) ? String.valueOf(serviceDomainId):StringPool.BLANK);
	
	String backURL = ParamUtil.getString(request, "backURL");
	
	List<ServiceBean> serviceBeans =  new ArrayList<ServiceBean>();
	
	List<ServiceBean> serviceBeansRecent =  new ArrayList<ServiceBean>();
	
	int totalCount = 0;
	
%>
<c:if test="<%=serviceDomainIdCHKInit.equals(\"-1\") %>">
	<div class="opencps-searchcontainer-wrapper default-box-shadow radius8">
	
		
		<div class="opcs-serviceinfo-list-label">
			<div class="title_box">
		           <p class="file_manage_title_new"><liferay-ui:message key="service-recent"/></p>
		           <p class="count"></p>
		    </div>
		</div>
		
		<liferay-ui:search-container searchContainer="<%= new ServiceSearch(renderRequest, 5, iteratorURL) %>">
		
			<liferay-ui:search-container-results>
				<%
					try{
						serviceBeansRecent = ServiceConfigLocalServiceUtil.getServiceConfigRecent(scopeGroupId, 
							themeDisplay.getUserId(), 1, -1, -1, 
							citizen != null ? 1 : -1, business != null ? 1 :-1, 0, 
							5, searchContainer.getOrderByComparator());
					}catch(Exception e){
						_log.error(e);			
					}
				
					total = serviceBeansRecent.size();
					results = serviceBeansRecent;
					
					pageContext.setAttribute("results", results);
					pageContext.setAttribute("total", total);
					
				%>
			</liferay-ui:search-container-results>	
				<liferay-ui:search-container-row 
					className="org.opencps.dossiermgt.bean.ServiceBean" 
					modelVar="serviceBean" 
					keyProperty="serviceConfigId"
				>
					<%
					
						DictItem dictItem = null;
					
						String domainName = StringPool.DASH;
						
						try{
							dictItem = DictItemLocalServiceUtil.getDictItem(GetterUtil.getLong(serviceBean.getDomainCode()));
							
							domainName = dictItem.getItemName(locale);
							
						}catch(Exception e){}
						
					%>
					
				
					<liferay-util:buffer var="service">
						<div class="row-fluid">
							<div class="span2 bold-label"><liferay-ui:message key="service-name"/></div>
							<div class="span10">
								<%=
									Validator.isNotNull(serviceBean.getServiceName()) ? 
									serviceBean.getServiceName() : StringPool.BLANK 
								%>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="domain">
						<div class="row-fluid min-width180">
							<div class="span5 bold-label"><liferay-ui:message key="domain-code"/></div>
							<div class="span7">
								<%=domainName %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="govAgency">
						<div class="row-fluid min-width180">
							<div class="span5 bold-label"><liferay-ui:message key="gov-agency-name"/></div>
							<div class="span7">
								<%=serviceBean.getGovAgencyName() %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="level">
						<div class="row-fluid min-width70">
							<div class="span9 bold-label"><liferay-ui:message key="level"/></div>
							<div class="span3">
								<%=String.valueOf(serviceBean.getLevel()) %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<%
						row.setClassName("opencps-searchcontainer-row");
						row.addText(String.valueOf(row.getPos() + 1 + searchContainer.getStart()));
						row.addText(service);
						row.addText(domain);
						row.addText(govAgency);
						row.addText(level);
						row.addJSP("center", SearchEntry.DEFAULT_VALIGN,"/html/portlets/dossiermgt/frontoffice/service_actions.jsp", config.getServletContext(), request, response);
					%>	
				</liferay-ui:search-container-row> 
			
			<liferay-ui:search-iterator paginate="false" />
		</liferay-ui:search-container>
	</div>
	<br/>
	<br/>
</c:if>
<aui:row>
	<aui:col width="25">
	
	<div style="margin-bottom: 25px;" class="opencps-searchcontainer-wrapper default-box-shadow radius8">
		
		<div id="serviceDomainIdTree" class="openCPSTree"></div>
		
		<%=ProcessOrderUtils.generateTreeView("serviceDomainId", "SERVICE_DOMAIN", "0", 
				LanguageUtil.get(locale, "filter-by-service-domain-left") , 0,"serviceDomainIdTree", "radio", "",
				false,renderRequest, iteratorURL)%>
		
	</div>
	<div class="opencps-searchcontainer-wrapper default-box-shadow radius8">
		
		<div id="govAgencyIdTree" class="openCPSTree"></div>
	
		<%=ProcessOrderUtils.generateTreeView("govAgencyId", "GOVERNMENT_AGENCY", "0", 
				LanguageUtil.get(locale, "filter-by-gov-agency-left") , 0,"govAgencyIdTree", "radio", "",
				true,renderRequest, iteratorURL)%>
	
	</div>
	
	
	</aui:col>
	<aui:col width="75" >

		<liferay-util:include page='<%=templatePath + "toolbar.jsp" %>' servletContext="<%=application %>" />
	<c:if test="<%=!serviceDomainIdCHKInit.equals(\"-1\") %>">
		<div class="opencps-searchcontainer-wrapper default-box-shadow radius8">

		<div class="opcs-serviceinfo-list-label">
			<div class="title_box">
		           <p class="file_manage_title"><liferay-ui:message key="list-service-config"/></p>
		           <p class="count"></p>
		    </div>
		</div>
	
		<liferay-ui:search-container searchContainer="<%= new ServiceSearch(renderRequest, SearchContainer.DEFAULT_DELTA, iteratorURL) %>">
		
			<liferay-ui:search-container-results>
				<%
					ServiceSearchTerms searchTerms = (ServiceSearchTerms)searchContainer.getSearchTerms();
				
					DictItem domainItem = null;
					
					DictItem govAgencygovItem = null;
				
					try{
						if(serviceDomainId > 0){
							domainItem = DictItemLocalServiceUtil.getDictItem(serviceDomainId);
						}
						
						if(govAgencyId > 0){
							govAgencygovItem = DictItemLocalServiceUtil.getDictItem(govAgencyId);
						}
		
						if(domainItem != null){
							searchTerms.setServiceDomainIndex(domainItem.getTreeIndex());
						}
						
						if(govAgencygovItem != null){
							searchTerms.setGovAgencyIndex(govAgencygovItem.getTreeIndex());
						}
						
						%>
							<%@include file="/html/portlets/dossiermgt/frontoffice/service_search_results.jspf" %>
						<%
					}catch(Exception e){
						_log.error(e);
					}
				
					total = totalCount;
					results = serviceBeans;
					
					pageContext.setAttribute("results", results);
					pageContext.setAttribute("total", total);
					
				%>
			</liferay-ui:search-container-results>	
				<liferay-ui:search-container-row 
					className="org.opencps.dossiermgt.bean.ServiceBean" 
					modelVar="serviceBean" 
					keyProperty="serviceConfigId"
				>
					<%
					
						DictItem dictItem = null;
					
						String domainName = StringPool.DASH;
						
						try{
							dictItem = DictItemLocalServiceUtil.getDictItem(GetterUtil.getLong(serviceBean.getDomainCode()));
							domainName = dictItem.getItemName(locale);
						}catch(Exception e){
							_log.error(e);
						}
					%>
					
					<liferay-util:buffer var="service">
						<div class="row-fluid">
							<div class="span2 bold-label"><liferay-ui:message key="service-name"/></div>
							<div class="span10">
								<%=
									Validator.isNotNull(serviceBean.getServiceName()) ? 
									serviceBean.getServiceName() : StringPool.BLANK 
								%>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="domain">
						<div class="row-fluid min-width180">
							<div class="span5 bold-label"><liferay-ui:message key="domain-code"/></div>
							<div class="span7">
								<%=domainName %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="govAgency">
						<div class="row-fluid min-width180">
							<div class="span5 bold-label"><liferay-ui:message key="gov-agency-name"/></div>
							<div class="span7">
								<%=serviceBean.getGovAgencyName() %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<liferay-util:buffer var="level">
						<div class="row-fluid min-width70">
							<div class="span9 bold-label"><liferay-ui:message key="level"/></div>
							<div class="span3">
								<%=String.valueOf(serviceBean.getLevel()) %>
							</div>
						</div>
					</liferay-util:buffer>
					
					<%
						row.setClassName("opencps-searchcontainer-row");
						row.addText(String.valueOf(row.getPos() + 1 + searchContainer.getStart()));
						row.addText(service);
						row.addText(domain);
						row.addText(govAgency);
						row.addText(level);
						row.addJSP("center", SearchEntry.DEFAULT_VALIGN,"/html/portlets/dossiermgt/frontoffice/service_actions.jsp", config.getServletContext(), request, response);
					%>
				</liferay-ui:search-container-row> 
			
			<liferay-ui:search-iterator type="opencs_page_iterator"/>
		</liferay-ui:search-container>
	</div>
	</c:if>

	</aui:col>
</aui:row>

<liferay-portlet:actionURL  var="menuCounterUrl" name="menuCounterAction"/>
<aui:script >
	var serviceDomainId = '<%=String.valueOf(serviceDomainId) %>';
	var govAgencyId = '<%=String.valueOf(govAgencyId) %>';
	
	AUI().ready(function(A){
		doCounterMenuCPS(null, "govAgencyIdTree", govAgencyId);
		doCounterMenuCPS(null, "serviceDomainIdTree", serviceDomainId);
	});
	Liferay.provide(window, 'doCounterMenuCPS', function(url, myTree ,active) {
		var A = AUI();
		
		var myTreeObj = A.one("#"+myTree);
		
		var allLI = myTreeObj.all( "li" );
		
		allLI.each(function (taskNode) {
			if(taskNode.getAttribute("id") === active){
				taskNode.addClass("current");
			}else{
				taskNode.removeClass("current");
			}
        });
		
	},['aui-base','liferay-portlet-url','aui-io']);
</aui:script>
<style>
.min-width180 {
    min-width: 150px !important;
}
</style>

<%!
	private Log _log = LogFactoryUtil.getLog("html.portlets.dossiermgt.frontoffice.frontofficeservicelist.jsp");
%>
