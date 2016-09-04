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
<%@page import="com.liferay.portal.kernel.dao.search.ResultRow"%>
<%@page import="org.opencps.dossiermgt.model.ServiceConfig"%>
<%@ include file="init.jsp"%>
<%
	ResultRow row =
	(ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
	ServiceConfig serviceConfig = (ServiceConfig) row.getObject();
// 	ServiceInfo service = (ServiceInfo) row.getObject();
	
	PortletURL submitOnlineURL = renderResponse.createRenderURL();
	submitOnlineURL.setParameter("mvcPath", templatePath + "dossier_submit_online.jsp");
	submitOnlineURL.setParameter("serviceConfigId", String.valueOf(serviceConfig.getServiceConfigId()));
// 	submitOnlineURL.setParameter("onlineURL", service.getOnlineUrl());
// 	submitOnlineURL.setParameter("backURL", currentURL);
%>
<aui:button value="service-description" href="<%=submitOnlineURL.toString() %>" cssClass="des-sub-button" />
