
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

<%@page import="com.liferay.portal.kernel.language.UnicodeLanguageUtil"%>

<%@ include file="../init.jsp"%>

<%
	String tabs1 = ParamUtil.getString(request, "tabs1", ServiceUtil.TOP_TABS_SERVICE);
	PortletURL searchURL = renderResponse.createRenderURL();
	
	String administrationCode = ParamUtil.getString(request, ServiceDisplayTerms.SERVICE_ADMINISTRATION);
	
	String domainCode = ParamUtil.getString(request, ServiceDisplayTerms.SERVICE_DOMAINCODE);
	
	request.setAttribute(ServiceDisplayTerms.SERVICE_ADMINISTRATION, administrationCode);
	
	request.setAttribute(ServiceDisplayTerms.SERVICE_DOMAINCODE, domainCode);
	
	DictCollection collectionDomain = null;
	DictItem curDictItem = null;
	try {
		collectionDomain = DictCollectionLocalServiceUtil.getDictCollection(scopeGroupId, WebKeys.SERVICE_DOMAIN);
	} catch (Exception e) {
		
	}
	
	List<DictItem> dictItems = new ArrayList<DictItem>();
	
	if(Validator.isNotNull(collectionDomain)) {
		dictItems = DictItemLocalServiceUtil.getDictItemsByDictCollectionId(collectionDomain.getDictCollectionId());
	}
	
%>
<aui:nav-bar cssClass="opencps-toolbar custom-toolbar">
	<aui:nav id="toolbarContainer" cssClass="nav-display-style-buttons pull-left" >
		<c:choose>
			<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_SERVICE) %>">
				<%
					searchURL.setParameter("mvcPath", templatePath + "serviceinfolist.jsp");
					searchURL.setParameter("tabs1", ServiceUtil.TOP_TABS_SERVICE);
				%>
				
				<portlet:renderURL var="editServiceURL">
					<portlet:param name="mvcPath" value='<%= templatePath + "edit_service-ux.jsp" %>'/>
					<portlet:param name="redirectURL" value="<%=currentURL %>"/>
					<portlet:param name="backURL" value="<%=currentURL %>"/>
				</portlet:renderURL>
				
				<c:if test="<%=ServicePermission.contains(permissionChecker, scopeGroupId, ActionKeys.ADD_SERVICE) %>">
					<aui:button icon="icon-plus" href="<%=editServiceURL %>" cssClass="action-button" value="add-service"/>
				</c:if>
			</c:when>
			
			<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_TEMPLATE) %>">
				<%
					searchURL.setParameter("mvcPath", templatePath + "servicetemplatefilelist.jsp");
					searchURL.setParameter("tabs1", ServiceUtil.TOP_TABS_TEMPLATE);
				%>

				<portlet:renderURL var="editTemplateURL">
					<portlet:param name="mvcPath" value='<%= templatePath + "edit_template.jsp" %>'/>
					<portlet:param name="redirectURL" value="<%=currentURL %>"/>
					<portlet:param name="backURL" value="<%=currentURL %>"/>
				</portlet:renderURL>
				
				<aui:row>
					<c:if test="<%= ServiceTemplatePermission.contains(permissionChecker, scopeGroupId, ActionKeys.ADD_TEMPLATE) %>">
						<aui:button icon="icon-plus" href="<%=editTemplateURL %>" cssClass="action-button" value="add-template"/>
					</c:if>
				</aui:row>
			</c:when>
			
			<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_DOMAIN) %>">
				<portlet:renderURL var="editDomainURL" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
					<portlet:param name="mvcPath" value='<%= templatePath + "edit_domain.jsp" %>'/>
					<portlet:param name="backURL" value="<%=currentURL %>"/>
					<portlet:param name="tabs1" value="<%=tabs1 %>"/>
				</portlet:renderURL>
							
				<c:if test="<%= ServiceTemplatePermission.contains(permissionChecker, scopeGroupId, ActionKeys.ADD_TEMPLATE) %>">
					<aui:nav-item 
                                id="addServiceDomain" 
                                label="add-domain" 
                                iconCssClass="icon-plus"  
                                href="<%= \"javascript:\" + renderResponse.getNamespace() + \"showPopup('\" + editDomainURL +\"');\" %>"
                    />
					<%-- <aui:button 
						icon="icon-plus" 
						href="<%=
								\"javascript:\" +  \"openDialog('\" + 
								editDomainURL + \"','\" + 
								renderResponse.getNamespace() + \"updateServiceDomain\" + \"','\" +
								UnicodeLanguageUtil.get(pageContext, \"update-service-domain\") +
								\"');\" 
							%>"
						cssClass="action-button" 
						value="add-domain"
					/> --%>
				</c:if>
			</c:when>
			
			<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_ADMINISTRATION) %>">
				<portlet:renderURL var="editServiceAdministrationURL" windowState="<%=LiferayWindowState.POP_UP.toString() %>">
					<portlet:param name="mvcPath" value='<%= templatePath + "edit_administration.jsp" %>'/>
					<portlet:param name="backURL" value="<%=currentURL %>"/>
					<portlet:param name="tabs1" value="<%=tabs1 %>"/>
				</portlet:renderURL>
							
				<c:if test="<%= ServiceTemplatePermission.contains(permissionChecker, scopeGroupId, ActionKeys.ADD_TEMPLATE) %>">
				    <aui:nav-item 
                                id="addServiceAdmin" 
                                label="add-administration" 
                                iconCssClass="icon-plus"  
                                href="<%= \"javascript:\" + renderResponse.getNamespace() + \"showPopup('\" + editServiceAdministrationURL +\"');\" %>"
                    />
					<%-- <aui:button 
						icon="icon-plus" 
						href="<%=
								\"javascript:\" +  \"openDialog('\" + 
								editServiceAdministrationURL + \"','\" + 
								renderResponse.getNamespace() + \"updateServiceAdministration\" + \"','\" +
								UnicodeLanguageUtil.get(pageContext, \"update-service-administration\") +
								\"');\" 
							%>"
						cssClass="action-button" 
						value="add-administration"
					/> --%>
				</c:if>
			</c:when>
			
		</c:choose>
	</aui:nav>
	
	<aui:nav-bar-search cssClass="pull-right">
		<div class="form-search">
			<aui:form action="<%= searchURL %>" method="post" name="fm">
				<div class="toolbar_search_input">
					<c:choose>
						<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_SERVICE) %>">
							<aui:row>
								<aui:col width="30" cssClass="search-col">
									<datamgt:ddr
										cssClass="search-input select-box"
										depthLevel="1" 
										dictCollectionCode="SERVICE_ADMINISTRATION"
										itemNames="<%= ServiceDisplayTerms.SERVICE_ADMINISTRATION %>"
										itemsEmptyOption="true"
										showLabel="<%=false %>"
										selectedItems="<%= administrationCode %>"	
										emptyOptionLabels="<%= ServiceDisplayTerms.SERVICE_ADMINISTRATION %>"
									>
									</datamgt:ddr>
	
								</aui:col>
								<aui:col width="30" cssClass="search-col">
									<%-- <datamgt:ddr
										cssClass="search-input select-box"
										depthLevel="1" 
										dictCollectionCode="SERVICE_DOMAIN"
										itemNames="<%= ServiceDisplayTerms.SERVICE_DOMAINCODE %>"
										itemsEmptyOption="true"	
										showLabel="<%=false %>"
										selectedItems="<%= domainCode %>"
										emptyOptionLabels="<%= ServiceDisplayTerms.SERVICE_DOMAINCODE %>"
									>
									</datamgt:ddr> --%>
									<aui:select name="<%=ServiceDisplayTerms.SERVICE_DOMAINCODE %>" label="">
										<aui:option value="">
											<liferay-ui:message key="<%=ServiceDisplayTerms.SERVICE_DOMAINCODE %>"/>
										</aui:option>
										<%
											if(dictItems != null){
												for(DictItem dictItem : dictItems){
													if((curDictItem != null && dictItem.getDictItemId() == curDictItem.getDictItemId())||
															(curDictItem != null && dictItem.getTreeIndex().contains(curDictItem.getDictItemId() + StringPool.PERIOD))){
														continue;
													}
													
													int level = StringUtil.count(dictItem.getTreeIndex(), StringPool.PERIOD);
													String index = "|";
													for(int i = 0; i < level; i++){
														index += "_";
													}
													%>
														<aui:option value="<%=dictItem.getDictItemId() %>"><%=index + dictItem.getItemName(locale) %></aui:option>
													<%
												}
											}
										%>
									</aui:select>
								</aui:col>
								<aui:col width="30" cssClass="search-col">
									<liferay-ui:input-search 
										id="keywords1"
										name="keywords"
										title='<%= LanguageUtil.get(locale, "keywords") %>'
										placeholder='<%= LanguageUtil.get(locale, "name") %>' 
										cssClass="search-input input-keyword"
									/>
								</aui:col>
							</aui:row>

						</c:when>
						
						<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_TEMPLATE) %>">
							<liferay-ui:input-search 
								id="keywords1" 
								name="keywords" 
								title='<%= LanguageUtil.get(locale, "keywords") %>'
								placeholder='<%= LanguageUtil.get(locale, "name") %>' 
								cssClass="search-input input-keyword"
							/>
						</c:when>
						
						<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_DOMAIN) %>">
	
						</c:when>
						
						<c:when test="<%= tabs1.contentEquals(ServiceUtil.TOP_TABS_ADMINISTRATION) %>">
			
						</c:when>
						
					</c:choose>
				</div>
			</aui:form>
		</div>
	</aui:nav-bar-search>
</aui:nav-bar>
<aui:script>
    Liferay.provide(window, '<portlet:namespace />showPopup', function(url){
        Liferay.Util.openWindow({
            dialog : {
                centered : true,
                height : 800,
                modal : true,
                width : 800
            },
            id : '<portlet:namespace/>dialog',
            title : '',
            uri : url
        });
    });
</aui:script>

<%!
	private Log _log = LogFactoryUtil.getLog("html.portlets.servicemgt.admin.toolbar.jsp");
%>