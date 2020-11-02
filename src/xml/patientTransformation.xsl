<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patientTransformation.xsl
    Created on : 17 octobre 2020, 19:20
    Author     : DELL
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cabinet="http://www.ujf-grenoble.fr/l3miage/medical"
    xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'>
    <xsl:output method="xml"/>
    
    <xsl:variable name="Patient" select="//cabinet:patient"/>
    <xsl:variable name="actePatient" select="//cabinet:patient/cabinet:visite[@intervenant=001]/cabinet:acte/@id"/>
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/">
        <html>
            <head>
                <title>patientTransformation.xsl</title>
            </head>
            <body>
                <xsl:apply-templates select="$Patient[2]"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="cabinet:patient">
        <h3>Patient :</h3>
            <li>Nom : <xsl:value-of select="cabinet:nom" /></li>
            <li>Prénom : <xsl:value-of select="cabinet:prénom" /></li>
            <li>Sexe : <xsl:value-of select="cabinet:sexe" /></li>
            <li>Date de naissance : <xsl:value-of select="cabinet:naissance" /></li>
            <li>Adresse : <xsl:value-of select="cabinet:adresse" /></li>
            <li>Numéro sécurité sociale : <xsl:value-of select="cabinet:numéro" /></li>
            <li>Visite : 
                <li>Date :<xsl:value-of select="cabinet:visite/@date" /></li> 
                <li>Intervenant :<xsl:value-of select="cabinet:visite/@intervenant" /></li> 
                <li>Acte : <xsl:apply-templates select="$actes/act:actes/act:acte[@id=$actePatient]"/></li>
            </li>
    </xsl:template>

</xsl:stylesheet>
