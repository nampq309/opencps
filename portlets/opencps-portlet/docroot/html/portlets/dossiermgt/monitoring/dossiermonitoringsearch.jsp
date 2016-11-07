
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

<%@page import="org.opencps.util.PortletConstants"%>
<%@page import="java.text.Format"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.theme.ThemeDisplay"%>
<%@page import="com.liferay.portal.kernel.util.WebKeys"%>
<%@page import="com.liferay.portal.kernel.log.LogFactoryUtil"%>
<%@page import="com.liferay.portal.kernel.log.Log"%>
<%@page import="com.liferay.portal.kernel.exception.SystemException"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.liferay.portal.kernel.util.FastDateFormatFactoryUtil"%>
<%@page import="org.opencps.dossiermgt.service.DossierStatusLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.model.DossierStatus"%>
<%@page import="org.opencps.servicemgt.service.ServiceInfoLocalServiceUtil"%>
<%@page import="org.opencps.servicemgt.model.ServiceInfo"%>
<%@page import="org.opencps.dossiermgt.service.DossierLocalServiceUtil"%>
<%@page import="org.opencps.datamgt.service.DictItemLocalServiceUtil"%>
<%@page import="org.opencps.datamgt.model.DictItem"%>
<%@page import="org.opencps.datamgt.service.DictCollectionLocalServiceUtil"%>
<%@page import="org.opencps.datamgt.model.DictCollection"%>
<%@page import="org.opencps.dossiermgt.model.Dossier"%>
<%@page import="java.util.List"%>
<%@page import="org.opencps.dossiermgt.search.DossierSearchTerms"%>
<%@page import="org.opencps.dossiermgt.search.DossierNewProcessingSearch"%>

<%@ include file="../init.jsp"%>

<div class="featured">
    <div class="title-featured col-xs-12 col-sm-12 col-lg-12 span12">
        <div class="color-ogange"><span><liferay-ui:message key="beautiful-life"/></span></div>
        <div class="color-white">
            <span><liferay-ui:message key="slogan-key"/></span>
        </div>
    </div>
    <div class="login-register col-xs-12 col-sm-12 col-lg-12 span12">
        <div class="btn btn-primary">
            <a href="/login" title="<liferay-ui:message key="login-key"/>"><i class="icon-login"></i><liferay-ui:message key="login-key"/></a>
        </div>
        <div class="btn btn-register">
            <a href="/register" title="register-key"><i class="icon-register"></i><liferay-ui:message key="register-key"/></a>
        </div>
    </div>
    <div class="search col-xs-12 col-sm-6 col-lg-6 span6">
        <div class="search-inner">
            <div class="input-group">
                <div class = "home-search">
                    <liferay-util:include page="/html/portlets/dossiermgt/monitoring/toolbar.jsp" servletContext="<%=application %>" />
                </div>
            </div>
        </div>
    </div>
   <%--  <div class = "home-search">
    	<liferay-util:include page="/html/portlets/dossiermgt/monitoring/toolbar.jsp" servletContext="<%=application %>" />
    </div> --%>

<%
	Format dateFormatDate = FastDateFormatFactoryUtil.getDate(locale, timeZone);
	PortletURL iteratorURL = renderResponse.createRenderURL();
	iteratorURL.setParameter("mvcPath", templatePath + "dossiermonitoringsearch.jsp");	
%>

<c:if test="<%= false %>">
	<aui:row>
		<aui:col width="50">
			<liferay-ui:search-container searchContainer="<%= new DossierNewProcessingSearch(renderRequest, SearchContainer.DEFAULT_DELTA, iteratorURL) %>">
				<liferay-ui:search-container-results>
					<%
						DossierSearchTerms searchTerms = (DossierSearchTerms)searchContainer.getSearchTerms();
						Integer totalCount = 0;										
						List<Dossier> newdossierreceiveds = null;		
						//DictCollection dictCollection = DictCollectionLocalServiceUtil.getDictCollection(scopeGroupId, "DOSSIER_STATUS");
						//DictItem dictItem = DictItemLocalServiceUtil.getDictItemInuseByItemCode(dictCollection.getDictCollectionId(), "received");
						try {
							newdossierreceiveds = DossierLocalServiceUtil.getDossierByStatus(scopeGroupId, PortletConstants.DOSSIER_STATUS_NEW, searchContainer.getStart(), searchContainer.getEnd(), searchContainer.getOrderByComparator());
							totalCount = DossierLocalServiceUtil.countDossierByStatus(scopeGroupId,  PortletConstants.DOSSIER_STATUS_NEW);
						}catch(Exception e){
						}
					
						total = totalCount;
						results = newdossierreceiveds;
						
						pageContext.setAttribute("results", results);
						pageContext.setAttribute("total", total);
					%>
				</liferay-ui:search-container-results>	
				<liferay-ui:search-container-row 
					className="org.opencps.dossiermgt.model.Dossier" 
					modelVar="dossier" 
					keyProperty="dossierId"
				>
					<%						
						// no column
						row.addText(Validator.isNull(dossier.getModifiedDate()) ? "" : dateFormatDate.format(dossier.getModifiedDate()));

						//subjectname column
						row.addText(dossier.getSubjectName());
						
						ServiceInfo serviceInfo = ServiceInfoLocalServiceUtil.getServiceInfo(dossier.getServiceInfoId());
						//serviceinfo-name column
						row.addText(serviceInfo.getServiceName());					
					%>	
				</liferay-ui:search-container-row> 
			
				<liferay-ui:search-iterator type="opencs_page_iterator"/>
				
			</liferay-ui:search-container>	
		</aui:col>
		<aui:col width="50">
			<liferay-ui:search-container searchContainer="<%= new DossierNewProcessingSearch(renderRequest, SearchContainer.DEFAULT_DELTA, iteratorURL) %>">
			
				<liferay-ui:search-container-results>
					<%
						DossierSearchTerms searchTerms = (DossierSearchTerms)searchContainer.getSearchTerms();
						Integer totalCount = 0;										
						List<Dossier> newdossierreceiveds = null;		
						//DictCollection dictCollection = DictCollectionLocalServiceUtil.getDictCollection(scopeGroupId, "DOSSIER_STATUS");
						//DictItem dictItem = DictItemLocalServiceUtil.getDictItemInuseByItemCode(dictCollection.getDictCollectionId(), "done");
						try {
							newdossierreceiveds = DossierLocalServiceUtil.getDossierByStatus(scopeGroupId, PortletConstants.DOSSIER_STATUS_DONE, searchContainer.getStart(), searchContainer.getEnd(), searchContainer.getOrderByComparator());
							totalCount = DossierLocalServiceUtil.countDossierByStatus(scopeGroupId, PortletConstants.DOSSIER_STATUS_DONE);
						}catch(Exception e){
						}
					
						total = totalCount;
						results = newdossierreceiveds;
						
						pageContext.setAttribute("results", results);
						pageContext.setAttribute("total", total);
					%>
				</liferay-ui:search-container-results>	
					<liferay-ui:search-container-row 
						className="org.opencps.dossiermgt.model.Dossier" 
						modelVar="dossier" 
						keyProperty="dossierId"
					>
						<%						
							// no column
							row.addText(Validator.isNull(dossier.getModifiedDate()) ? "" : dateFormatDate.format(dossier.getModifiedDate()));
	
							//subjectname column
							row.addText(dossier.getSubjectName());
							
							ServiceInfo serviceInfo = ServiceInfoLocalServiceUtil.getServiceInfo(dossier.getServiceInfoId());
							//serviceinfo-name column
							row.addText(serviceInfo.getServiceName());					
						%>	
					</liferay-ui:search-container-row> 
				
				<liferay-ui:search-iterator type="opencs_page_iterator"/>
			</liferay-ui:search-container>	
		</aui:col>
	</aui:row>

</c:if>
</div>
<%!
	private Log _log = LogFactoryUtil.getLog("html.portlets.dossiermgt.monitoring.search.jsp");
%>
