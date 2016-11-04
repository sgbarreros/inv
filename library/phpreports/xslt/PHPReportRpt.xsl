<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:param name="sql"/>
<xsl:param name="user"/>			
<xsl:param name="pass"/>
<xsl:param name="conn"/>
<xsl:param name="interface"/>
<xsl:param name="database"/>
<xsl:param name="nodatamsg"/>
<xsl:param name="nodatafunc"/>
<xsl:param name="pagesize"/>

<xsl:param name="parameter1"/>
<xsl:param name="parameter2"/>
<xsl:param name="parameter3"/>
<xsl:param name="parameter4"/>
<xsl:param name="parameter5"/>
<xsl:param name="parameter6"/>
<xsl:param name="parameter7"/>
<xsl:param name="parameter8"/>
<xsl:param name="parameter9"/>
<xsl:param name="parameter10"/>

<xsl:param name="reference1"/>
<xsl:param name="reference2"/>
<xsl:param name="reference3"/>
<xsl:param name="reference4"/>
<xsl:param name="reference5"/>
<xsl:param name="reference6"/>
<xsl:param name="reference7"/>
<xsl:param name="reference8"/>
<xsl:param name="reference9"/>
<xsl:param name="reference10"/>

<xsl:template match="REPORT">
	<xsl:text>$oReport = new PHPReportRpt($aEnv_);&#10;</xsl:text>
	<xsl:if test="count(@MARGINWIDTH)>0">
		<xsl:text>&#9;$oReport->setMarginWidth(</xsl:text>
		<xsl:value-of select="@MARGINWIDTH"/>
		<xsl:text>);&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="count(@MARGINHEIGHT)>0">
		<xsl:text>&#9;$oReport->setMarginHeight(</xsl:text>
		<xsl:value-of select="@MARGINHEIGHT"/>
		<xsl:text>);&#10;</xsl:text>
	</xsl:if>
	<xsl:if test="count(@MAX_ROW_BUFFER)>0">
		<xsl:text>&#9;$oReport->setMaxRowBuffer(</xsl:text>
		<xsl:value-of select="@MAX_ROW_BUFFER"/>
		<xsl:text>);&#10;</xsl:text>
	</xsl:if>
	
	// create a default error object for translation, if needed
	$oError = new PHPReportsErrorTr();
	
	<xsl:call-template name="PARAMETERS"/>
	<xsl:call-template name="DATACON"/>

	// create a default page element
	$oPage = null;

	// document layer
	$oDoc = new PHPReportGroup("DOCUMENT LAYER");
	$oDoc->setFields($oFields);
	$oDoc->setReport(&amp;$oReport);
	$oGroup =&amp; $oDoc;
	
	<xsl:apply-templates/>

	// if there is a form
	if($oForm)
		$oDoc->setForm($oForm);
	
	// there must be a PAGE element here
	if(is_null($oPage))
		$oError->showMsg("NOPAGE");

	// if dinamically defined the page size (this overrides the XML value) ...	
	<xsl:if test="string-length($pagesize)>0">
		$oPage->setSize(<xsl:value-of select="$pagesize"/>);
	</xsl:if>
			
	$oPage->setFields($oFields);
	$oPage->setGroups(&amp;$oGrpMain_);
	
	$oDoc->setReport($oReport);
	$oDoc->addChild($oGrpMain_);
	$oPage->setDocument(&amp;$oDoc);

	$oPage->eventHandler(REPORT_OPEN);
	$oDoc->eventHandler(REPORT_OPEN);
	$bFound=false;

	$this->_aBench["output_start"] = time();

	// looping on the sql result here ...
	while($aResult=PHPReportsDBI::db_fetch($oStmt)) {
		$bFound=true;
		$oPage->eventHandler(PUT_DATA,$aResult);
		$oDoc->eventHandler(PROCESS_DATA,$aResult);
	}

	$oDoc->eventHandler(REPORT_CLOSE);
	$oPage->eventHandler(REPORT_CLOSE);	

	PHPReportsDBI::db_free($oStmt);
	PHPReportsDBI::db_disconnect($oCon);
	
	// no data found
	if(!$bFound){
		if(strlen($sNoDataFoundFunc)>0)
			eval($sNoDataFoundFunc.";");
			else{	
				if(strlen($sNoDataFoundMsg)>0)
					new PHPReportsError(strlen($sNoDataFoundMsg)>0?$sNoDataFoundMsg:"NO DATA FOUND");
				else
					$oError->showMsg("NODATA");
			}	
	}
</xsl:template>

<xsl:template match="REPORT/TITLE">
	<xsl:text>$oReport->setTitle(&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/PATH">
	<xsl:text>$oReport->setPath(&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/BACKGROUND_COLOR">
	<xsl:text>$oReport->setBackgroundColor(&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/BACKGROUND_IMAGE">
	<xsl:text>$oReport->setBackgroundImage(&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/CSS">
	<xsl:text>$oReport->addCSS(&quot;</xsl:text>
	<xsl:value-of select="."/><xsl:text>&quot;</xsl:text>
	<xsl:if test="count(@MEDIA)&gt;0">
		<xsl:text>,&quot;</xsl:text><xsl:value-of select="@MEDIA"/><xsl:text>&quot;</xsl:text>
	</xsl:if>
	<xsl:text>);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/BOOKMARKS_CSS">
	<xsl:text>$oReport->setBookmarksCSS(&quot;</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>&quot;);&#10;</xsl:text>
</xsl:template>

<xsl:template match="REPORT/SQL">
</xsl:template>

<xsl:template match="REPORT/USER">
</xsl:template>

<xsl:template match="REPORT/PASSWORD">
</xsl:template>

<xsl:template match="REPORT/INTERFACE">
</xsl:template>

<xsl:template match="REPORT/CONNECTION">
</xsl:template>

<xsl:template match="REPORT/DATABASE">
</xsl:template>

<xsl:template match="REPORT/TEMP">
</xsl:template>

<xsl:template match="REPORT/NO_DATA_MSG">
</xsl:template>

<xsl:template match="REPORT/NO_DATA_FUNC">
</xsl:template>

<xsl:template match="REPORT/DEBUG">
</xsl:template>

<xsl:template name="DATACON">
	// connecting to the database
	$sSQL    = &quot;<xsl:value-of select="SQL"/>&quot;;
	$sUser   = &quot;<xsl:value-of select="USER"/>&quot;;
	$sPass   = &quot;<xsl:value-of select="PASSWORD"/>&quot;;
	$sConn   = &quot;<xsl:value-of select="CONNECTION"/>&quot;;
	$sData   = &quot;<xsl:value-of select="DATABASE"/>&quot;;
	$sIf     = &quot;<xsl:value-of select="INTERFACE"/>&quot;;

	<xsl:if test="string-length($sql)>0">
	$sSQL    = &quot;<xsl:value-of select="$sql"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($user)>0">
	$sUser   = &quot;<xsl:value-of select="$user"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($pass)>0">
	$sPass   = &quot;<xsl:value-of select="$pass"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($conn)>0">
	$sConn   = &quot;<xsl:value-of select="$conn"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($database)>0">
	$sData   = &quot;<xsl:value-of select="$database"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($interface)>0">
	$sIf    = &quot;<xsl:value-of select="$interface"/>&quot;;
	</xsl:if>

	// include the database interface file
	$sIfFile = realpath($sPath."/database/db_".$sIf.".php");
	if(!file_exists($sIfFile))
		$oError->showMsg("NOIF",$sIf);
	include_once $sIfFile; 

	// open database connection
	if(is_null($this->_oCon))
		$oCon = @PHPReportsDBI::db_connect(Array($sUser,$sPass,$sConn,$sData)) or $oError->showMsg("REFUSEDCON");
	else 
		$oCon = $this->_oCon;

	if(!is_resource($oCon) &amp;&amp; !is_object($oCon))
		$oError->showMsg("INVALIDCON");

	// input filters
	if($this->_oFilters){
		foreach($this->_oFilters as $oFilter){
			$oFilter->setConnection($oCon);
			$oFilter->setSQL(trim($sSQL));
			$sSQL = trim($oFilter->run());
		}
	}

	$this->_aBench["sql_start"] = time();
	if(is_null($this->_oQuery))
		$oStmt = @PHPReportsDBI::db_query($oCon,trim($sSQL)) or $oError->showMsg("QUERYERROR");
	else
		$oStmt = $this->_oQuery;
	$this->_aBench["sql_end"] = time();

	// get info about the fields
	$oFields = Array();
	$iColNum = @PHPReportsDBI::db_colnum($oStmt);

	// if no columns were returned, weird!
	if($iColNum&lt;=0){
		@PHPReportsDBI::db_free($oStmt);
		$oError->showMsg("NOCOLUMNS");
	}
	
	for($i=1;$i&lt;=$iColNum;$i++) 
		$oFields[PHPReportsDBI::db_columnName($oStmt,$i)]=new PHPReportField(PHPReportsDBI::db_columnName($oStmt,$i),PHPReportsDBI::db_columnType($oStmt,$i));	
</xsl:template>

<xsl:template name="PARAMETERS">
	$oParameters    = Array();
	$oParameters[0] = null; // nothing here
	
	<xsl:if test="string-length($parameter1)>0">
		$oParameters[<xsl:value-of select="$reference1"/>]=&quot;<xsl:value-of select="$parameter1"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter2)>0">
		$oParameters[<xsl:value-of select="$reference2"/>]=&quot;<xsl:value-of select="$parameter2"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter3)>0">
		$oParameters[<xsl:value-of select="$reference3"/>]=&quot;<xsl:value-of select="$parameter3"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter4)>0">
		$oParameters[<xsl:value-of select="$reference4"/>]=&quot;<xsl:value-of select="$parameter4"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter5)>0">
		$oParameters[<xsl:value-of select="$reference5"/>]=&quot;<xsl:value-of select="$parameter5"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter6)>0">
		$oParameters[<xsl:value-of select="$reference6"/>]=&quot;<xsl:value-of select="$parameter6"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter7)>0">
		$oParameters[<xsl:value-of select="$reference7"/>]=&quot;<xsl:value-of select="$parameter7"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter8)>0">
		$oParameters[<xsl:value-of select="$reference8"/>]=&quot;<xsl:value-of select="$parameter8"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter9)>0">
		$oParameters[<xsl:value-of select="$reference9"/>]=&quot;<xsl:value-of select="$parameter9"/>&quot;;
	</xsl:if>
	<xsl:if test="string-length($parameter10)>0">
		$oParameters[<xsl:value-of select="$reference10"/>]=&quot;<xsl:value-of select="$parameter10"/>&quot;;
	</xsl:if>
	$oReport->setParameters($oParameters);

	// no data found message
	<xsl:if test="string-length(/REPORT/NO_DATA_MSG)>0">
		$sNoDataFoundMsg=&quot;<xsl:value-of select="/REPORT/NO_DATA_MSG"/>&quot;;
	</xsl:if>	
	<xsl:if test="string-length($nodatamsg)>0">
		$sNoDataFoundMsg=&quot;<xsl:value-of select="$nodatamsg"/>&quot;;
	</xsl:if>

	// no data found function
	<xsl:if test="string-length(/REPORT/NO_DATA_FUNC)>0">
		$sNoDataFoundFunc=&quot;<xsl:value-of select="/REPORT/NO_DATA_FUNC"/>&quot;;
	</xsl:if>	
	<xsl:if test="string-length($nodatafunc)>0">
		$sNoDataFoundFunc=&quot;<xsl:value-of select="$nodatafunc"/>&quot;;
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
