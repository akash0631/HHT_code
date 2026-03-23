<%@page import="com.sap.conn.jco.JCoFieldIterator"%>
<%@page import="com.sap.conn.jco.JCoStructure"%>
<%@page import="com.sap.conn.jco.JCoField"%>
<%@page import="com.sap.conn.jco.JCoParameterFieldIterator"%>
<%@page import="com.sap.conn.jco.JCoParameterList"%>
<%@page import="com.sap.conn.jco.JCoFunction"%>
<%@page import="com.sap.conn.jco.JCoTable"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
        <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css">
        <link href="http://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
		<script src="js/jquery.table2excel.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>After Execution</title>
<script type="text/javascript" >
			
			function convertToExcel()
			{
				$("#responceData").table2excel({
    				name: "Excel Document"
				});
			}
</script>

</head>


<body>


<form id="bapiDetail">
<table width="100%" height="80%" border="0" cellspacing="0">
<tr><td width="5%" bgcolor="#e8e8e8"></td>
	<td width="90%" align="center">
		<div style="height:100%;align:Center; ">
		<table width = "100%">
				<tr><td><h1 style="font-size: 1.8em; color: #01538f; text-align: left;"><%=request.getParameter("bapiName")%></h1></td></tr>
			</table></div>
			<div style=" width:100%; ">
          <table width = "100%" align="center">
	<%
	String bapiName = request.getParameter("bapiName");
	System.out.print(" Here");
	JCoFunction function = (JCoFunction) request.getAttribute("RFCNAME");
	out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.5em; color: #01538f; text-align: left;\">Import Parameters</td></tr>");
	processRfcParamters(function.getImportParameterList(),out);	
	out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.5em; color: #01538f; text-align: left;\">Export Parameters</td></tr>");
	processRfcParamters(function.getExportParameterList(),out);	
	out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.5em; color: #01538f; text-align: left;\">Table Parameters</td></tr>");
	processRfcParamters(function.getTableParameterList(),out);		
	%>
	</table></div></td></tr>							
	</table>
</form>

</body>
</html>

<%!
public void  processRfcParamters(JCoParameterList paramList,JspWriter out){
	JCoParameterFieldIterator plistIterate = null;
	boolean flagFunctionExecute = true;
	try{ 
	if(paramList != null){
		 plistIterate = paramList.getParameterFieldIterator();
		
		while(plistIterate.hasNextField()){
		JCoField field = plistIterate.nextField();
		if(field.isStructure()){
			out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.2em; color: #01538f; text-align: left;\">Structure Name  "+field.getName()+" <div></td></tr>");
			processStructure(field.getStructure(),out);
		}else if(field.isTable()){
			out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.2em; color: #01538f; text-align: left;\">Table Name  "+field.getName()+" <div></td></tr>");
			processTable(field.getTable(),out);
		}else
			processIndependField(field,out);
		}
	}
}catch(Exception e){
		
	}
}

public void processTable(JCoTable table,JspWriter out){
	try{
	out.print("<tr><td>Number of Rows:--------->"+table.getNumRows()+"<p id='dwn' onclick='convertToExcel()' class='btn btn-success'>Export</p></div></td></tr>");
	out.println("<tr><td width = \"100 %\"><table border = 1  id='responceData'><thead><tr bgcolor=\"red\">");
	//out.println("<tr><b><td>Table Name--->"+field.getName()+"<b></td>");

	JCoFieldIterator fieldIterate = table.getFieldIterator();
	while(fieldIterate.hasNextField()){
		JCoField tablefield = fieldIterate.nextField();
		out.print("<th>"+tablefield.getName()+" ("+tablefield.getDescription()+")</th>");
	}
	out.println("</tr></thead><tbody>");
	
	for(int k = 0;k<table.getNumRows();k++,table.nextRow()){
		out.print("<tr>");
		for(int l = 0;l < table.getNumColumns();l++)
			out.print("<td>"+table.getString(l)+"</td>");
		out.print("</tr>");
	}
	out.print("</tbody></table></td></tr>");
	}catch(Exception e){
		
	}
 }

private void processStructure(JCoStructure struct,JspWriter out){
	try{
	out.println("<tr><td width = \"100 %\"><table border = 1 ><thead><tr bgcolor=\"red\"><th> Name </th><th> Description </th>"
			+"<th>Value </th></tr></thead><tbody>");

	//System.out.print(";"+field.getStructure().getStructure(field.getName()));
	
	JCoFieldIterator fieldIterate = struct.getFieldIterator();
	
	while(fieldIterate.hasNextField()){
		JCoField structField = fieldIterate.nextField();
		out.print("<tr><td>"+structField.getName()+"</td>");
		out.print("<td>"+structField.getDescription()+"</td>");
		out.print("<td>"+structField.getValue()+"</td><tr>");
	}
	out.print("</tbody></table></td></tr>");
	}catch(Exception e){
		
	}

}

private void processIndependField(JCoField field,JspWriter out){
	try{
		out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1em;  text-align: left;\">"+field.getName()+ " --> Value --->"+field.getValue()+"</div></td></tr>");
		//out.print("<tr><td width = \"100 %\">"+field.getName()+" --> Value --->"+field.getValue()+"</td></tr>");
	}catch(Exception e){
		
	}
}

%>

		