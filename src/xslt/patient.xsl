<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cm="http://www.ujf-grenoble.fr/l3miage/medical"
    version="1.0"
>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="destinedName" select="Pien"></xsl:param>
    <xsl:variable name="ngap" select="document('../xml/actes.xml', /)/ngap"/>

    <xsl:template match="/">
        <patient>
            <xsl:apply-templates select="//cm:patient[cm:nom=$destinedName]/*"/>
        </patient>
    </xsl:template>

    <!--
        Templates permettant de copier des noeuds directement d'un document à l'autre (sans l'espace de nom).
        Source : https://stackoverflow.com/questions/19998180/xsl-copy-nodes-without-xmlns
    -->
    <xsl:template match="*" mode="copy-no-namespaces">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="copy-no-namespaces"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="comment()| processing-instruction()" mode="copy-no-namespaces">
        <xsl:copy/>
    </xsl:template>


    <!-- <xsl:template name="elementToElement">
        <xsl:variable name="elementName" select="name()"/>
        <xsl:element name="{$elementName}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template> -->

    <xsl:template match="cm:patient/*[not(name()='visite'))]">
        <xsl:apply-templates select="." mode="copy-no-namespaces"/>
    </xsl:template>

    <!-- <xsl:template match="cm:patient/cm:adresse">
        <adresse>
            <xsl:apply-templates select="*"/>
        </adresse>
    </xsl:template> -->

    <!-- <xsl:template match="cm:patient/cm:adresse/*">
        <xsl:call-template name="elementToElement"/>
    </xsl:template> -->

    <xsl:template match="cm:patient/cm:visite">
        <xsl:variable name="idIntervenant" select="@intervenant"/>
        <xsl:element name="visite">
            <xsl:attribute name="date"><xsl:value-of select="@date"/></xsl:attribute>
            <intervenant>
                <nom><xsl:value-of select="//cm:infirmier[@id=$idIntervenant]/cm:nom"/></nom>
                <prénom><xsl:value-of select="//cm:infirmier[@id=$idIntervenant]/cm:prénom"/></prénom>
            </intervenant>
            <xsl:apply-templates select="cm:acte"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="cm:patient/cm:visite/cm:acte">
        <xsl:variable name="idActe" select="@id"/>
        <acte>
            <xsl:choose>
                <xsl:when test="not(.='')">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($ngap//acte[@id=$idActe])"/>
                </xsl:otherwise>
            </xsl:choose>
        </acte>
    </xsl:template>

</xsl:stylesheet>