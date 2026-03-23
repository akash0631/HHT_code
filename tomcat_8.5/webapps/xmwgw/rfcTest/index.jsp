
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>Middleware Xml Generator</title>
<body>


<form id="BapiInput" name ="BapiInput" method="post" action="BapiExportDetail.jsp">
    <table width = "100%" height = "100%" border="0" cellspacing = "0">
	<tr><td width="5%" bgcolor="#e8e8e8"></td><td width="90%" align="center">
		<div style="width:100%; height: 100%; text-align: left;">
			You can Test the RFC <br /><br /></div>
	<table>
	
	<tr>
		<td  class="formlabel" width = "30%">Rfc Name</td>
		<td width="70%"><input type="text" id = "bapiName"  name = "bapiName" class="formfield" /></td>
	</tr>

	
    <tr><td><br><br></td></tr>
 	<tr><td></td><td><input type="submit" value="Test"></td></tr>
 	<tr><td><br><br></td></tr>
 	
 	<tr><td><br><br></td></tr>
 	
</table>
</td></tr></table>
</form>

</body>
</html>