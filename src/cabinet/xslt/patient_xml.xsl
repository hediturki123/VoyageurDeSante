<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cm="http://www.ujf-grenoble.fr/l3miage/medical" version="1.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="destinedName">Orouge</xsl:param>
    <xsl:variable name="ngap" select="document('../xml/actes.xml', /)/ngap"/>

    <xsl:template match="/">
        <xsl:text>&#013;</xsl:text>
        <patient>
            <xsl:apply-templates select="//cm:patient[cm:nom=$destinedName]/*"/>
        </patient>
    </xsl:template>

    <!--
        Pour tous les noeuds du patient qui ne sont pas des visites,
        on peut recopier directement les informations.
    -->
    <xsl:template match="*[not(name()='visite')]">
        <xsl:apply-templates select="." mode="copy-no-namespaces"/>
    </xsl:template>

    <!--
        Pour chaque visite, on indique le nom et le prénom de l'intervenant,
        ainsi que les actes qui seront effectués.
    -->
    <xsl:template match="cm:patient/cm:visite">
        <xsl:variable name="idIntervenant" select="@intervenant"/>
        <xsl:element name="visite">
            <xsl:attribute name="date">
                <xsl:value-of select="@date"/>
            </xsl:attribute>
            <intervenant>
                <nom>
                    <xsl:value-of select="//cm:infirmier[@id=$idIntervenant]/cm:nom"/>
                </nom>
                <prénom>
                    <xsl:value-of select="//cm:infirmier[@id=$idIntervenant]/cm:prénom"/>
                </prénom>
            </intervenant>
            <xsl:apply-templates select="cm:acte"/>
        </xsl:element>
    </xsl:template>

    <!--
        Pour chaque acte du patient, si celui-ci possède une dénomination personnalisée,
        on la met directement. Sinon, on va la chercher dans le document contenant les actes.
     -->
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

    <!--
        Templates de copie de nœuds sans espace de noms.
        Source : https://stackoverflow.com/a/20001084
    -->
    <xsl:template match="*[normalize-space(.)!='']" mode="copy-no-namespaces">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()[normalize-space(.)!='']" mode="copy-no-namespaces"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="comment()| processing-instruction()" mode="copy-no-namespaces">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>