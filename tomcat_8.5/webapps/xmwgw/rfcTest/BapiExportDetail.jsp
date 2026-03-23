<%@page import="com.dotvik.xmw.saputils.RfcXmlUtil"%>
<%@page import="com.dotvik.xmw.adapterSapBean.*"%>
<%@page import="com.sap.conn.jco.JCoField"%>
<%@page import="com.sap.conn.jco.JCoParameterFieldIterator"%>
<%@page import="com.sap.conn.jco.JCoParameterList"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.Format"%>
<%@page import="com.sap.conn.jco.JCoDestination"%>
<%@page import="com.sap.conn.jco.JCoDestinationManager"%>
<%@page import="com.sap.conn.jco.JCoFunction"%>
<%@page import="com.sap.conn.jco.JCoTable"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<title>Bapi Data Check </title>
<script type="text/javascript" >
//script method for add the column 

function bapiExportDetail(validateFieldName,isOptionalVal) {
	alert("bapiExportDetail");
	if(mandatoryCheckBapiExport(validateFieldName,isOptionalVal) == false) return;

	var userForm = document.forms['BapiExportDetail'];
	userForm.submit();
}


function mandatoryCheckBapiExport(validateFieldName,isOptionalVal){
	
	//alert("In the madatory Check");
	var validFieldNameArr = new Array();
	var validFieldDescArr = new Array();
	validFieldNameArr = validateFieldName.split("&");
	validFieldDescArr = isOptionalVal.split("&");
	//alert("validFieldNameArr.length "+validFieldNameArr.length);
	//alert("validFieldDescArr.length "+validFieldDescArr.length);
	var len = 0;
//	boolean flagStructureTable = false;

	while(len < validFieldNameArr.length){
		if((validFieldDescArr[len])== 'false' && document.forms['BapiExportDetail'].elements[validFieldNameArr[len]].value == '' ){
				alert("Please Enter "+validFieldNameArr[len]  );
				document.forms['BapiExportDetail'].elements[validFieldNameArr[len]].focus();
				return false;
		}
	len++;
	}
	return true;
}


function addColumn(id){
	tblId = "addrow"+id;

	var tblHeadObj = document.getElementById(tblId).tHead;
	for (var h=0; h<tblHeadObj.rows.length; h++) {
		var newTH = document.createElement('th');
		tblHeadObj.rows[h].appendChild(newTH);
		newTH.innerHTML = 'Add Row:'+ (tblHeadObj.rows[h].cells.length - 6);
	}
	alert ("Here i am:==>"+tblId); 
	test = document.getElementById(tblId);

	//alert ("Here i am:333333==>"+test.tBodies[0]); 
	var tblBodyObj = document.getElementById(tblId).tBodies[0];
	alert ("Here i am:4444==>"+tblBodyObj.rows.length); 
	for (var i=0; i<tblBodyObj.rows.length; i++) {
		//alert ("Here i am:==>"+tblBodyObj.rows[i].id); 
		var newCell = tblBodyObj.rows[i].insertCell(-1);
		var idForTextField = id+"_"+tblBodyObj.rows[i].id+"_"+(tblBodyObj.rows[i].cells.length-6);
		
		var inputField = document.createElement("input");
		inputField.setAttribute("type", "text");
		inputField.setAttribute("id",idForTextField);
		inputField.setAttribute("name",idForTextField);
		//inputField.setAttribute("value",idForTextField);
		newCell.appendChild(inputField);
	//	alert ("Here i am00000:==>"+ id+"_"+(i+1)+"_"+tblBodyObj.rows[i].cells.length-6);
		//newCell.innerHTML =  '<input type="text" id ="'+id+'_'+(i+1)+'_'+tblBodyObj.rows[i].cells.length-6+'" value="'+id+'_'+(i+1)+'_'+tblBodyObj.rows[i].cells.length -6+'"  name="'+id+'_'+(i+1)+'_'+tblBodyObj.rows[i].cells.length-6+'" />';
		//newCell.innerHTML = '[td] row:' + i + ', cell: ' + (tblBodyObj.rows[i].cells.length - 6);
	}
}
function deleteColumn(id){
	tblId = "addrow"+id.substring(2);
	var allRows = document.getElementById(tblId).rows;
	for (var i=0; i<allRows.length; i++) {
		if (allRows[i].cells.length > 6) {
			allRows[i].deleteCell(-1);
		}
	}
}
</script>
<body>
<%! String checkBoxName = "";
	String isOptionalVal = ""; 
	int  fieldNumber = 1;%>

<form id="BapiExportDetail" name="BapiExportDetail" method="post" action="RfcTestExecute">
<table width="100%" height="80%" border="0" cellspacing="0">
<tr><td width="5%" bgcolor="#e8e8e8"></td>
	<td width="90%" align="center">
		<div style="height:100%; width:60%;">
		<table width = "100%">
				<tr><td><h1 style="font-size: 1.8em; color: #01538f; text-align: left;"><%=request.getParameter("bapiName")%></h1></td></tr>
			</table></div>
			<div style="height:100%; width:60%;font-size: 1.4em; color: #01538f; text-align: center;">
			Enter the Data For Bapi Detail</div>
			<input type = "hidden" id="bapiName" name="bapiName" value="<%=request.getParameter("bapiName")%>"/> 
         <div style=" width:100%;">
          <table width = "100%" align="center">
 	<%  
		checkBoxName = "";
		isOptionalVal = "";
		String bapiName = request.getParameter("bapiName");
		
		RfcXmlUtil xmlUtil = new RfcXmlUtil(request.getParameter("bapiName"));
		IntegrationMetaInfo rfcMeta = xmlUtil.makeIntegrationXmlFile();
		request.getSession().setAttribute("RFCTESTObj",rfcMeta);
		

		processRfcParamters(rfcMeta.getImportParameters(),out,"Import");
		processRfcParamters(rfcMeta.getTableParameters(),out,"Table");
	%>
	<tr><td align = "center"><input type="submit" value="Submit" onclick="return bapiExportDetail(checkBoxName,isOptionalVal)"/></td></tr>
	</table></div></td></tr>

</table>
</form>

</body>

</html>

<%!
public void processRfcParamters(IntegrationParameters  rfcParam,JspWriter out,String paramType){
	try{
		fieldNumber = 1;
		out.println("<tr><td><div style=\"font-size: 1.5em; color: #01538f; text-align: left;\">"+paramType+" Parameters </div></td></tr>");
		makeFieldsTable(rfcParam.getIndependentFields(),out,paramType,paramType);
		processTableStructure(rfcParam.getStructures(),out,"Structure");
		processTableStructure(rfcParam.getTables(),out,"Table");
		
	}catch(Exception e){
		
	}
}
public void processTableStructure(HashMap<String, IntegrationRecordMetaInfo> structure,JspWriter out,
		String paramType){
	try{
	if (structure.size() > 0){
		out.println("<tr><td width = \"100 %\"> <div style=\"font-size: 1.2em; color: #01538f; text-align: left;\">"+fieldNumber+". " +paramType+"s <div></td></tr>");
		fieldNumber ++;
	}
	int i = 1;
	for (String key : structure.keySet()) {
		IntegrationRecordMetaInfo recordMeta = structure.get(key);
		if(paramType.equals("Table")){
			out.println("<tr><td><div style=\"font-size: 1.0em; color: #01538f; text-align: left ;\">"+(fieldNumber-1)+"."+i+"  "+recordMeta.getName()+" </div></td></tr>"
					+" <tr ><td > <div style=\"font-size: 1.0em; text-align: left; float: left; \">&nbsp;&nbsp; Name&nbsp;&nbsp;&nbsp;&nbsp;"
					+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + recordMeta.getName()+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
					+"&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" id=\"checkbox"+recordMeta.getName()+"\" name=\"checkbox"+recordMeta.getName()+"\" value=\""+recordMeta.getName()+"\" />"			
					+"<input type=\"BUTTON\" id =\""+recordMeta.getName()+"\"  value=\"Add Row\" name =\""+recordMeta.getName()+"\" / onclick = \"addColumn(this.id);\">"
			+"<input type=\"BUTTON\" id =\"d_"+recordMeta.getName()+"\"  value=\"Delete Row\" name =\"d_"+recordMeta.getName()+"\" / onclick = \"deleteColumn(this.id);\"></div></td></tr>");
						
		}else{
			out.println("<tr><td><div style=\"font-size: 1.0em; color: #01538f; text-align: left ;\">"+(fieldNumber-1)+"."+i+"  "+recordMeta.getName()
			+"&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" id=\"checkbox"+recordMeta.getName()+"\" name=\"checkbox"+recordMeta.getName()+"\" value=\""+recordMeta.getName()+"\" /></div></td></tr>"
				+" <tr ><td > <div style=\"font-size: 1.0em; text-align: left; float: left; \">&nbsp;&nbsp; Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + recordMeta.getName());
		}
		out.println("<tr><td><div style=\"font-size: 1.0em; text-align: left;\">&nbsp;&nbsp; Description&nbsp;&nbsp;&nbsp;&nbsp"
				+ recordMeta.getDescription() + " </div></td></tr>");
		out.println("<tr><td><div style=\"font-size: 1.0em; text-align: left;\">&nbsp;&nbsp; Optional&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
				+ (recordMeta.isOptional()+"") + " </div></td></tr>");
		i++;
		makeFieldsTable(recordMeta.getFields(),out,recordMeta.getName(),"addrow"+recordMeta.getName());
		System.out.print("checkbox id:===> "+"checkbox"+recordMeta.getName());
	 }
	}catch(Exception e){
		
	}
}



//method is for the independets fields
public void makeFieldsTable(HashMap<String,FieldParameter> independedField,JspWriter out,
		String paramType,String tableId){
	try{
		if (independedField.size() > 0) {
			out.println("<tr><td width = \"100 %\"><table border = 1 width = \"100 %\" id = \""+tableId+"\"><thead><tr bgcolor=\"red\"><th> Name </th><th> Desc </th>"
					+"<th>Type </th><th> Optional </th><th> Length </th><th> Default </th><th> Enter Data </th></tr></thead><tbody>");
		}
		int itemNo = 1;
		for (String key : independedField.keySet()) {
			FieldParameter fieldParam = independedField.get(key);
			String elementName = "";
			if(paramType.equalsIgnoreCase("Import")||paramType.equalsIgnoreCase("Export"))
				elementName = fieldParam.getName();
			else
				elementName = paramType+"_"+fieldParam.getName()+"_1";
			System.out.println("Name of Field "+fieldParam.getName()+"elementName Id :---> " +elementName);
			out.println("<tr id =\""+fieldParam.getName()+"\" ><td>" + fieldParam.getName() + "</td><td>"
					+ fieldParam.getDescription() + "</td><td>"
					+ fieldParam.getType() + "</td><td>"
					+ fieldParam.isOptional() + "</td><td>"
					+ fieldParam.getLength() + "</td><td>"
					+ fieldParam.getDefaultVal() + "</td>");
			
			out.println("<td><input type=\"text\" id =\""+elementName+"\"  value=\""+fieldParam.getDefaultVal()+"\" name =\""+elementName+"\" /> </td></tr>");
			itemNo++;
			checkBoxName += elementName+"&";
			isOptionalVal += true+"&";
		}
		if (independedField.size() > 0)
			out.println("</tbody></table></td></tr>");

		System.out.println("independedField :---> "+ independedField.size());
	}catch(Exception e){
		
	}
}
%>
         
          
