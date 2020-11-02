<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : fiche_patient.xsl
    Created on : 17 octobre 2020, 19:53
    Author     : DELL
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes" 
    xmlns:patient="http://www.ujf-grenoble.fr/l3miage/patient_NOMPATIENT"
    xmlns:cabinet="http://www.ujf-grenoble.fr/l3miage/medical">
    
    <xsl:output method="html"/>
    
    <xsl:variable name="Patient" select="//patient:li"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/">
        <html>
            <head>
                <title>fiche_patient.xsl</title>
            </head>
            <body>
                <xsl:apply-templates select="$Patient"/>
            </body>
        </html>
    </xsl:template>
    
    
    <xsl:template match="patient:li">
        <li> 
            <xsl:value-of select="."/>
        </li>
    </xsl:template>

</xsl:stylesheet>
