<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@	page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${sessionScope.loggedUser.username}</title>
	<link rel="stylesheet" type="text/css" href="./style/main.css" />
	<script type="text/javascript"></script>
</head>
<body>
<c:set var="allUsers" value="${sessionScope.allUsers}" />
<!-- This is the currently logged in user. -->
<c:set var="loggedUser" value="${sessionScope.loggedUser}" />

<!-- This is the user whose profile we are currently viewing. -->
<c:set var="selectedUser" value="${requestScope.selectedUser}" />
<c:set var="selectedCategory" value="${requestScope.selectedCategory}" />
<c:set var="photoPages" value="${requestScope.photoPages}" />
<c:set var="pageIndex" value="${requestScope.pageIndex}" />
<c:choose>
	<c:when test="${!empty selectedCategory}">
		<c:set var="subCategories" value="${selectedCategory.categories}" />
	</c:when>
	<c:otherwise>
		<c:set var="subCategories" value="${selectedUser.categories}" />
	</c:otherwise>
</c:choose>

<table class="mainTable" cellpadding="0" cellspacing="0" align="center">
	<tr><td class="mainTop" colspan="3">
		<div class="mainTopLogo">
			<img src="./images/headBG.png" class="noBorder" USEMAP="#link" />
			<map name="link"><area shape="rect" coords="15,10,225,60" href="mainPage.jsp">
			</map>
			<div class="mainTopBanner">
				<div><a href='' title="" class="headerTexLinks">Дали това не е най-големият сайт за снимки в България?!</a>
				</div>
			</div>
		</div>
		</td>
	</tr>
	<tr><td class="vseparator">&nbsp;</td></tr>
	<tr><td colspan="3" class="mainTopMenu">
		<table cellpadding="0" cellspacing="0" class="flex">
			<tr><td class="left pLeft10">Най-големият сайт за снимки в България!</td>
				<td class="right pRight10">
					<c:choose>
						<c:when test="${empty loggedUser}">
							<a href="register.jsp">Регистрация</a>
							<span class="separator"><img src="./images/separator.png" align="middle" style="vertical-align: middle;" /></span>
						</c:when>
						<c:otherwise>
							<font style="font-size: 12px;">
								<c:out value='Добре дошъл, ${loggedUser.firstName} ${loggedUser.lastName}' />
								<span class="separator"><img src="./images/separator.png" align="middle" style="vertical-align: middle;" /></span>
							</font>
							<a href="./login?action=logout">Изход</a>
							<span class="separator"><img src="./images/separator.png" align="middle" /></span>
						</c:otherwise>
					</c:choose>
					<a href="SearchServlet">Търсене</a>
					<span class="separator"><img src="./images/separator.png" align="middle" /></span>
					<a href="Help.jsp">Помощ</a>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr><td class="mainLeft vtop">
			<table cellpadding="0" cellspacing="0" class="leftMenu">
				<tr><td colspan="2" class="headerMin" style="border-bottom: 3px solid #fabc01;">
						<div>Подкатегории</div>
					</td>
				</tr>
				<c:if test="${empty subCategories}">
					<tr><td class="leftItem pTop10">&nbsp;</td>
						<td class="rightItem pTop10"><b>Няма</b></td>
					</tr>
				</c:if>
				<c:forEach var="category" items="${subCategories}">
					<tr><td class="leftItem pTop10">
							<img src="./images/bullet.png" class="bullet" alt="bullet" />
						</td>
						<td class="rightItem pTop10">
							<a href="./user?userId=${selectedUser.userId}&categoryId=${category.categoryId}">
								<c:out value="${category.catName}" />
							</a>
						</td>
					</tr>
				</c:forEach>
				<tr><td class="leftItem lh10">&nbsp;</td>
					<td class="rightItem lh10">&nbsp;</td>
				</tr>
				<tr><td colspan="2" class="bottomMin">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td colspan="2" class="mainCenterNone vtop">
				<table cellpadding="0" cellspacing="0" class="flex" align="center" >
					<tr><td class="vtop">
						<table cellpadding="0" cellspacing="0" class="mainSearch top10" align="center">
							<tr><td class="headerBorder headerMid center">
									<div style="width: 400px;">Търси в най-големият сайт за снимки в България</div>
								</td>
							</tr>
							<tr><td class="mainSearchTd">
								<div class="fLeft pLeft10 pTop10">
									<form action="SearchServlet" method="post">
										<table cellpadding="0" cellspacing="0" class="searchTable" align="center">
											<tr align="center">
												<td width="100px">Име на снимка: </td>
												<td width="160px"><input type="text" class="textInput" name="searchName" id="searchName" /></td>
												<td colspan="2" width="130px">
													<input type="submit" class="button" style="width:90px;" name="btnSearch" value="Търси" />
												</td>
												<%	String search = (String) request.getAttribute("search");
													if (search != null) {
												%>	<tr><td><%= search %></td></tr>
												<%	} %>
											</tr>
										</table>
									</form>
								</div>
								</td>
							</tr>
							<tr><td class="mainSearchTd lh10">&nbsp;</td></tr>
							<tr><td class="bottomMid">&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
			<c:if test="${!empty selectedCategory && !empty photoPages}">
				<table class="tabsMiddle top10" cellpadding="0" cellspacing="0">
					<tr><td class="tabs">
							<div class="leftTabStub">&nbsp;</div>
							<div class="tab tabSelected bold">${selectedCategory.catName}</div>
							<div class="rightTabStub">&nbsp;</div>
						</td>
					</tr>
					<tr><td class="tabsTableMiddle" align="center">
							<div class="loadingMiddle" style="display:none;">&nbsp;</div>
							<div style="width: 80%;" align="left">
								<c:forEach var="photo" items="${photoPages[pageIndex].photos}">
									<div class="smallestProfile">
										<div class="smallProfilePicOffline">
											<a href="">
												<img class="pic" src="${photoPages[pageIndex].absolutePaths[photo.path]}" alt=${photo.phName} title=${photo.phName} />
											</a>
										</div>
										<div class="vipPic">&nbsp;</div>
										<div class="lh17">
											<a href="" class="link bold">${photo.phName}</a>
										</div>
										<div class="lh17">Коментари <span class="bold">0</span></div>
									</div>
								</c:forEach>
							</div>
						</td>
					</tr>
					<tr><td class="tabsBottomMid">
							<div class="fLeft left10">
								<a href=""><img src="./images/btnLeft.gif" /></a>
								<a href=""><img src="./images/btnRight.gif" /></a>
								<span>${pageIndex} от 0</span>
							</div>
							<div class="fRight right10">
								<div style="line-height:17px;">
									<a href="" class="link">Виж всички потребители &raquo;</a>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</c:if>
		</td>
	</tr>
	<tr><td colspan="3" style="line-height: 0px; height: 10px;">&nbsp;</td>
	</tr>
	<tr><td colspan="3" class="mainBottom">
		<div>
			<div class="fLeft vtop left10 top10">
				<a class="link" href="http://academy.devbg.org/">Контакти</a><span class="separator">|</span>
				<a class="link" href="Advertisement.jsp">Реклама</a><span class="separator">|</span>
				<a class="link" href="Dot.jsp">Права и задължения</a><span class="separator">|</span>
				<a class="link" href="Help.jsp">Помощ</a><span class="separator">|</span>
				<div class="left">
					<div style="padding-top: 10px;padding-bottom: 10px;">
						<span class="separator" />
						<span class="separator" />
					</div>
				</div>
			</div>
			<div class="fRight vtop right10 top10">
				Copyright © 2007-2007 Менте Софтуер<br>
				<div class="right">Web Design: НАРС</div>
			</div>
		</div>
		</td>
	</tr>
</table>
</body>
</html>