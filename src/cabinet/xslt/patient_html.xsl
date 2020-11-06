<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" cdata-section-elements="script"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyzšœÿàáâãäåæçèéêëìíîïðñòóôöøùúûüýþ'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZŠŒŸÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÖØÙÚÛÜÝÞ'" />

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#013;</xsl:text>
        <html>
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
                <title>
                    <xsl:text>Voyageur de Santé • </xsl:text>
                    <xsl:value-of select="patient/prénom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="patient/nom"/>
                </title>

                <!-- CSS -->
                <link rel="stylesheet" href="../../css/bootstrap.min.css"/>
                <link rel="stylesheet" href="../../css/main.css"/>
            </head>
            <body>
                <xsl:apply-templates select="patient"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="patient">
        <section class="container-fluid">
            <div class="jumbotron">
                <div class="media">
                    <xsl:element name="img">
                        <xsl:attribute name="src">
                            <xsl:text>../../img/patient/</xsl:text>
                            <xsl:value-of select="nom"/>
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="prénom"/>
                            <xsl:text>.jpg</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="prénom"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">align-self-center img-thumbnail mr-4</xsl:attribute>
                        <xsl:attribute name="style">width:10%;</xsl:attribute>
                    </xsl:element>
                    <div class="media-body align-self-center">
                        <h1 class="display-4">Bonjour <strong>
                            <xsl:value-of select="prénom"/>
                        </strong>
                    </h1>
                    <p class="lead">Vous avez <xsl:value-of select="count(visite)"/>
 visite(s) à venir.</p>
                </div>
            </div>
        </div>
    </section>
    <section class="container">
        <div class="row row-cols-1">
            <div class="col card m-2">
                <div class="card-body">
                    <h3 class="card-title">Récapitulatif de vos infos</h3>
                    <hr/>
                    <table class="table table-sm table-borderless">
                        <tbody>
                            <tr>
                                <th scope="col">Nom</th>
                                <th scope="col">Prénom</th>
                                <th scope="col">Sexe</th>
                                <th scope="col">
                                    <abbr title="Numéro d'Inscription au Répertoire">NIR</abbr>
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    <xsl:value-of select="translate(nom,$smallcase,$uppercase)"/>
                                </td>
                                <td>
                                    <xsl:value-of select="prénom"/>
                                </td>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="sexe='M'">Homme</xsl:when>
                                        <xsl:when test="sexe='F'">Femme</xsl:when>
                                        <xsl:when test="sexe='A'">Autre</xsl:when>
                                        <xsl:when test="sexe='I'">Indéfini</xsl:when>
                                        <xsl:otherwise>Non renseigné</xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td>
                                    <xsl:value-of select="numéro"/>
                                </td>
                            </tr>
                            <tr></tr>
                            <tr>
                                <th scope="col" colspan="2">Adresse</th>
                                <th scope="col">Visites à venir</th>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <xsl:apply-templates select="adresse"/>
                                </td>
                                <td>
                                    <xsl:value-of select="count(visite)"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
    <section class="container">
        <div class="row row-cols-3">
            <xsl:apply-templates select="visite"/>
        </div>
    </section>
</xsl:template>

<!-- Template pour l'affichage des visites sous forme de cartes. -->
<xsl:template match="patient/visite">
    <div class="col card m-2">
        <div class="card-body">
            <h5 class="card-title">
                <xsl:text>Visite du </xsl:text>
                <xsl:call-template name="formatDate">
                    <xsl:with-param name="date" select="@date"/>
                </xsl:call-template>
            </h5>
            <h6 class="card-subtitle mb-3 text-muted">
                <xsl:text>Intervenant(e) : </xsl:text>
                <strong>
                    <xsl:value-of select="intervenant/prénom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="translate(intervenant/nom,$smallcase,$uppercase)"/>
                </strong>
            </h6>
            <table class="table table-bordered table-sm table-striped">
                <thead>
                    <tr>
                        <th scope="col">
                            <xsl:text>Soins à effectuer </xsl:text>
                            <span class="badge badge-primary badge-pill">
                                <xsl:value-of select="count(acte)"/>
                            </span>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="acte"/>
                </tbody>
            </table>
        </div>
    </div>
</xsl:template>

<!-- Représentation d'un soin à effectuer (acte) par une ligne de tableau. -->
<xsl:template match="patient/visite/acte">
    <tr>
        <td><xsl:value-of select="."/></td>
    </tr>
</xsl:template>

<!-- Template pour l'affichage de l'adresse. -->
<xsl:template match="patient/adresse">
    <xsl:choose>
        <xsl:when test="count(numéro) &gt; 0">
            <xsl:value-of select="numéro"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="rue"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="
                    concat(
                        translate(
                            substring(rue,1,1),
                            $smallcase,
                            $uppercase
                        ),
                        substring(rue,2,string-length(rue)-1)
                    )
                "/>
        </xsl:otherwise>
    </xsl:choose>
    <br/>
    <xsl:value-of select="codePostal"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="translate(ville,$smallcase,$uppercase)"/>
    <xsl:if test="count(étage) &gt; 0">
        <br/>
        <xsl:text>&#201;tage </xsl:text>
        <xsl:value-of select="étage"/>
    </xsl:if>
</xsl:template>

<!-- Template de formatage de la date au format jj/mm/aaaa. -->
<xsl:template name="formatDate">
    <xsl:param name="date"/>
    <xsl:value-of select="
            concat(
                substring($date,9,2),'/',
                substring($date,6,2),'/',
                substring($date,1,4)
            )"/>
</xsl:template>

</xsl:stylesheet>