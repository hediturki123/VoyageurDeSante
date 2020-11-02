<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cabinet.xsl
    Created on : 13 octobre 2020, 15:44
    Author     : DELL
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:cabinet="http://www.ujf-grenoble.fr/l3miage/medical"
    xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'>
    
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:variable name="visitesDuJour" select="//cabinet:patient/cabinet:visite[@intervenant=001]"/>
    <xsl:variable name="actePatient" select="//cabinet:patient/cabinet:visite[@intervenant=001]/cabinet:acte/@id"/>
    <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap"/>
 
    <xsl:template match="/">
        <html>
            <head>
                <title>cabinet.xsl</title>
                <link rel="stylesheet" type="text/css" href="cabinet.css"/>
                <script type="text/javascript" src="cabinet.js"/>
            </head>
            <body>
                <h1>Cabinet d'infirmieres</h1>
                
                <h2>Bonjour 
                    <xsl:call-template name="id">
                        <xsl:with-param name="destinedId" select="cabinet:cabinet/cabinet:infirmiers/cabinet:infirmier/@id"/>
                    </xsl:call-template>   ,                 
                </h2>
                <h2>Aujourd'hui vous avez <xsl:value-of select="count(cabinet:cabinet/cabinet:patients/cabinet:patient/cabinet:visite/@intervenant)"/>
                    patients
                </h2>
                <p>
                    <h3>
                        <b>Patients : </b>
                            <xsl:apply-templates select="$visitesDuJour/.."/>
                            
                    </h3>
                </p>
                
            </body>
        </html>
    </xsl:template>
    
     <xsl:template name="id">
        <xsl:param name="destinedId" select="001"/>    
        <xsl:value-of select="cabinet:cabinet/cabinet:infirmiers/cabinet:infirmier/cabinet:prénom" />
    </xsl:template>
    
    
    <xsl:template match="cabinet:patient">
          <h3>Patient :</h3>
            <li>Nom : <xsl:value-of select="cabinet:nom" /></li>
            <li>Prénom : <xsl:value-of select="cabinet:prénom" /></li>
            <li>Adresse : <xsl:value-of select="cabinet:adresse" /></li>
            <li>Acte : n°<xsl:value-of select="$actePatient" /> , 
            <xsl:apply-templates select="$actes/act:actes/act:acte[@id=$actePatient]"/>
            <br>
                <input type="button" class="Privat" value="Facture">
                    <xsl:attribute name="onclick">
                        openFacture('<xsl:value-of select="cabinet:prénom"/>', 
                                    '<xsl:value-of select="cabinet:nom"/>', 
                                    '<xsl:value-of select="$actePatient"/>')
                    </xsl:attribute>     
                </input>
            </br>
            </li>  
    </xsl:template>
    
    <xsl:template match="act:acte[@id=$actePatient]">
            <xsl:value-of select="." />
    </xsl:template>
    
</xsl:stylesheet>
