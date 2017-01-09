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

<%@ include file="/init.jsp" %>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil" %>
<%@page import="com.liferay.portal.model.Group" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>

<%  
	String businessRegStep_cfg = GetterUtil.getString(portletPreferences.getValue("businessRegStep", StringPool.BLANK));
	String citizenRegStep_cfg = GetterUtil.getString(portletPreferences.getValue("citizenRegStep", StringPool.BLANK));
	List<Group> groupList=GroupLocalServiceUtil.getGroups(0, GroupLocalServiceUtil.getGroupsCount());
	List<Group> sites = new ArrayList<Group>();
	for(Group group : groupList){
	    if (group.getType() == 1 && group.isSite()) {
	        sites.add(group);
        }
	}
%>