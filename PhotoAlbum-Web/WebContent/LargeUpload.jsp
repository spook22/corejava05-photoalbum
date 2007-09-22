<%@ page language="java" import="javazoom.upload.*,java.util.*"%>
<%@ page errorPage="ExceptionHandler.jsp" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@	page import="photoalbum.PhotoAlbumManipulator"%>
<%@	page import="photoalbum.entities.Category"%>
<%@	page import="photoalbum.logging.Logger"%>

<%	int fileSizeLimit = 5242880; %>
<%	String whiteList = "*.png,*.gif,*.jpg"; %>

<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean">
	<jsp:setProperty name="upBean" property="storemodel" value="<%= UploadBean.MEMORYSTORE %>" />
	<jsp:setProperty name="upBean" property="filesizelimit" value="<%= fileSizeLimit %>" />
	<jsp:setProperty name="upBean" property="whitelist" value="<%= whiteList %>" />
</jsp:useBean>

<html>
<head>
	<title>Качете снимка си във фото албума</title>
	<style TYPE="text/css">
		.style1 {
			font-size: 12px;
			font-family: Verdana;
		}
	</style>
</head>
<body>
<ul class="style1">
<%	PhotoAlbumManipulator pam = new PhotoAlbumManipulator();
	Category category = (Category) session.getAttribute("categoryPhoto");
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
		//	Parse multipart HTTP POST request.
		MultipartFormDataRequest mrequest = null;
		try {
			mrequest = new MultipartFormDataRequest(request);
			if (mrequest != null) {
				upBean.store(mrequest);
				String todo = mrequest.getParameter("todo");
				if ( todo != null && todo.equalsIgnoreCase("upload") ) {
					Vector uploadFiles = upBean.getMemorystore();
					for (Object obj : uploadFiles) {
						UploadFile uploadFile = (UploadFile) obj;
						String fileName = uploadFile.getFileName();
						byte[] image = uploadFile.getData();
						pam.addPhoto(category, fileName, image);
					}
				} else {
					out.println("<br/> todo=" + todo);
				}
			}
		} catch (Exception e) {
			Logger.getDefaultInstance().log(e);
		} finally {
			upBean.resetStore();
		}
	} 
%>
</ul>
<form method="post" action="LargeUpload.jsp" name="upform" enctype="multipart/form-data">
	<table width="60%" border="0" cellspacing="1" cellpadding="1" align="center" class="style1">
		<tr>
			<td align="left"><b>Изберете снимка :</b></td>
		</tr>
		<tr><td align="left">
				<input type="hidden" name="todo" value="upload">
				<input type="file" name="uploadfile" size="50">
			</td>
		</tr>
		<tr><td align="left"><input type="submit" name="Submit"
				value="Upload"> <input type="reset" name="Reset"
				value="Cancel">
			</td>
		</tr>
		<tr><td>
				<div><a class="grey" href="MainPage.jsp">Начална страница</a></div>
			</td>
		</tr>
	</table>
</form>
</body>
</html>