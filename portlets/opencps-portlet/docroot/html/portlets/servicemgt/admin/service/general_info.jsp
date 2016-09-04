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

<%@ include file="../../init.jsp" %>
<%@page import="org.opencps.util.WebKeys"%>
<%@page import="org.opencps.servicemgt.model.ServiceInfo"%>
<%@page import="org.opencps.dossiermgt.search.DossierDisplayTerms"%>
<%@page import="org.opencps.dossiermgt.service.ServiceConfigLocalServiceUtil"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>

<%
	ServiceInfo serviceInfo = (ServiceInfo) request.getAttribute(WebKeys.SERVICE_ENTRY);
	long serviceInfoId = (serviceInfo != null) ? serviceInfo.getServiceinfoId() : 0L;
	long submitOnlinePlid = PortalUtil.getPlidFromPortletId(scopeGroupId, true,  WebKeys.P26_SUBMIT_ONLINE);
	
	long plidResLong = 0;
	
	if(Long.valueOf(plidRes) ==0) {
		plidResLong = submitOnlinePlid;
	} else {
		plidResLong = Long.valueOf(plidRes);
	}
	
	ServiceConfig serviceConfig = null;
	
	try {
		serviceConfig = ServiceConfigLocalServiceUtil.getServiceConfigByG_S(scopeGroupId, serviceInfoId);
	} catch (Exception e) {
		
	}
	
%>
<liferay-portlet:renderURL 
		var="servieOnlinePopURL" 
		portletName="<%=WebKeys.P26_SUBMIT_ONLINE %>"
		plid="<%=plidResLong %>"
		portletMode="VIEW"
	>
		<portlet:param name="mvcPath" value="/html/portlets/dossiermgt/submit/dossier_submit_online.jsp"/>
		<portlet:param name="serviceinfoId" value="<%=String.valueOf(serviceInfoId) %>"/>
</liferay-portlet:renderURL>


<aui:model-context bean="<%= serviceInfo %>" model="<%= ServiceInfo.class %>"/>

<aui:row>
	<aui:col width="100">
		<aui:input name="<%= ServiceDisplayTerms.SERVICE_NAME %>" ></aui:input>
	</aui:col>
</aui:row>

<aui:row>
	<aui:col width="50">
		<aui:input name="<%= ServiceDisplayTerms.SERVICE_NO %>"></aui:input>
	</aui:col>
	<aui:col width="50">
		<aui:input name="<%= ServiceDisplayTerms.SERVICE_FULLNAME %>"></aui:input>
	</aui:col>
</aui:row>
<aui:row>
	<aui:col>
		<datamgt:ddr 
			cssClass="input100"
			depthLevel="1" 
			dictCollectionCode="SERVICE_ADMINISTRATION"
			itemNames="<%= ServiceDisplayTerms.SERVICE_ADMINISTRATION %>"
			itemsEmptyOption="true"
			selectedItems="<%= Validator.isNotNull(serviceInfo) ? serviceInfo.getAdministrationCode() : StringPool.BLANK %>"
		>
		</datamgt:ddr>
	</aui:col>
</aui:row>

<aui:row>
	<aui:col>
		<datamgt:ddr 
			cssClass="input100"
			depthLevel="1" 
			dictCollectionCode="SERVICE_DOMAIN"
			itemNames="<%= ServiceDisplayTerms.SERVICE_DOMAINCODE %>"
			itemsEmptyOption="true"
			selectedItems="<%= Validator.isNotNull(serviceInfo) ? serviceInfo.getDomainCode() : StringPool.BLANK %>"
		>
		</datamgt:ddr>
	</aui:col>
</aui:row>

<%-- <aui:row>
	<aui:col width="100">
		<c:choose>
			<c:when test="<%=Validator.isNotNull(serviceInfo) && Validator.isNull(serviceInfo.getOnlineUrl())%>">
				<aui:input cssClass="input100" name="urlOnline" type="text" value="<%=servieOnlinePopURL.toString() %>"/>
			</c:when>
			<c:otherwise>
				<aui:input cssClass="input100" name="<%= ServiceDisplayTerms.SERVICE_ONLINEURL %>" />
			</c:otherwise>
		</c:choose>	
	</aui:col>
</aui:row> --%>

<aui:row>
	<aui:col width="100">
		<aui:select name="<%= ServiceDisplayTerms.SERVICE_ACTIVESTATUS %>" showEmptyOption="true">
			<aui:option value="0">
				<liferay-ui:message key="service-private"/>
			</aui:option>
			<aui:option value="1">
				<liferay-ui:message key="service-public"/>
			</aui:option>
			<aui:option value="2">
				<liferay-ui:message key="service-outdate"/>
			</aui:option>
		</aui:select>
	</aui:col>
</aui:row>
