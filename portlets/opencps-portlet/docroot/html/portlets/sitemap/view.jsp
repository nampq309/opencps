<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme"%>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui"%>

<portlet:defineObjects />

<liferay-theme:defineObjects />

<ul class="sitemap-class">
    <li><a href="http://192.168.73.129/web/guest/huong-dan-su-dung"><liferay-ui:message key="dvc.site-map.tutorial" /></a></li>
    <li><a href="/dang-ky-tai-khoan">
            <liferay-ui:message key="dvc.site-map.register-account" /></a></li>
    <li><a
        href="http://192.168.73.129/web/guest/dang-nhap-he-thong">
            <liferay-ui:message key="dvc.site-map.login" /></a></li>
    <li><a
        href="/nop-ho-so-truc-tuyen">
            <liferay-ui:message key="dvc.site-map.submit-online" /></a></li>
    <li><a
        href="/can-bo-xu-ly-ho-so">
            <liferay-ui:message key="dvc.site-map.cbxl" /></a></li>
</ul>
