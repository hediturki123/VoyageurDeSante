<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cm="http://www.ujf-grenoble.fr/l3miage/medical"
    version="1.0"
>
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" cdata-section-elements="script"/>

    <xsl:param name="destinedId">001</xsl:param>
    <xsl:variable name="visites" select="//cm:patient/cm:visite[@intervenant=$destinedId]"/>
    <xsl:variable name="intervenant" select="//cm:infirmier[@id=$destinedId]"/>
    <xsl:variable name="ngap" select="document('../data/actes.xml', /)/ngap"/>
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
                    <xsl:value-of select="$intervenant/cm:prénom"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$intervenant/cm:nom"/>
                </title>

                <!-- CSS -->
                <link rel="stylesheet" href="css/bootstrap.min.css"/>
                <link rel="stylesheet" href="css/main.css"/>
            </head>
            <body>
                <section class="container-fluid">
                    <div class="jumbotron">
                        <div class="media">
                            <xsl:element name="img">
                                <xsl:attribute name="src">
                                    <xsl:text>img/infirmier/</xsl:text>
                                    <xsl:value-of select="//cm:infirmier[@id=$destinedId]/cm:photo"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt"><xsl:value-of select="//cm:infirmier[@id=$destinedId]/cm:prénom"/></xsl:attribute>
                                <xsl:attribute name="class">align-self-center img-thumbnail mr-4</xsl:attribute>
                                <xsl:attribute name="style">width:10%;</xsl:attribute>
                            </xsl:element>
                            <div class="media-body align-self-center">
                                <h1 class="display-4">Bonjour <strong><xsl:value-of select="//cm:infirmier[@id=$destinedId]/cm:prénom"/></strong></h1>
                                <p class="lead">Vous avez <xsl:value-of select="count($visites)"/> visite(s) à venir.</p>
                            </div>
                        </div>
                    </div>
                </section>
                <xsl:call-template name="listeVisites"/>

                <!-- JS -->
                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"/>
                <script src="js/bootstrap.min.js"/>
                <script src="js/facture.js"></script> 
            </body>
        </html>
    </xsl:template>

    <xsl:template name="listeVisites">
        <section class="container">
            <ul class="list-group">
                <xsl:apply-templates select="$visites">
                    <xsl:sort select="cm:visite/@date"/>
                    <xsl:sort select="cm:nom"/>
                </xsl:apply-templates>
            </ul>
        </section>
    </xsl:template>

    <xsl:template match="cm:visite">
        <xsl:variable name="patient" select=".."/>
        <xsl:variable name="actesPatient" select="cm:acte"/>
        <xsl:variable name="dateVisite" select="@date"/>

        <li itemscope="" itemtype="https://schema.org/Patient" class="list-group-item">
            <div class="media">
                <xsl:element name="img">
                    <xsl:attribute name="src">
                        <xsl:text>img/patient/</xsl:text>
                        <xsl:value-of select="$patient/cm:nom"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="$patient/cm:prénom"/>
                        <xsl:text>.jpg</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="alt"><xsl:value-of select="$patient/cm:prénom"/></xsl:attribute>
                    <xsl:attribute name="class">align-self-start img-thumbnail mr-3</xsl:attribute>
                    <xsl:attribute name="style">width:10%;</xsl:attribute>
                    <xsl:attribute name="itemprop">image</xsl:attribute>
                </xsl:element>
                <div class="media-body">
                    <h5 class="mt-0 mb-1">
                        <xsl:choose>
                            <xsl:when test="$patient/cm:sexe = 'M'">
                                <small>M.</small><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="$patient/cm:sexe = 'F'">
                                <small>Mme</small><xsl:text> </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <span itemprop="name"><xsl:value-of select="$patient/cm:prénom"/></span>
                        <xsl:text> </xsl:text>
                        <span itemprop="familyName"><xsl:value-of select="translate($patient/cm:nom, $smallcase, $uppercase)"/></span>
                    </h5>
                    <h6 class="mt-0 mb-4">
                        <small>Visite le</small>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="formatDate">
                            <xsl:with-param name="date" select="@date"/>
                        </xsl:call-template>
                    </h6>
                    <table class="table table-sm table-borderless mb-4">
                        <thead>
                            <tr>
                                <th scope="col">Naissance</th>
                                <th scope="col">Adresse</th>
                                <th scope="col">NIR</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <xsl:call-template name="formatDate">
                                        <xsl:with-param name="date" select="$patient/cm:naissance" />
                                    </xsl:call-template>
                                </td>
                                <td>
                                    <xsl:apply-templates select="$patient/cm:adresse"/>
                                </td>
                                <td>
                                    <xsl:value-of select="$patient/cm:numéro" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="table table-striped mb-4">
                        <thead class="thead-acts">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Soin à effectuer</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:apply-templates select="cm:acte"/>
                        </tbody>
                    </table>
                    <xsl:element name="button">
                        <xsl:attribute name="type">button</xsl:attribute>
                        <xsl:attribute name="class">btn btn-primary</xsl:attribute>
                        <xsl:attribute name="onclick">
                            afficherFacture('<xsl:value-of select="$patient/cm:prénom"/>',
                            '<xsl:value-of select="$patient/cm:nom"/>',
                            '<xsl:value-of select="$patient/cm:visite/cm:acte/@id"/>')
                        </xsl:attribute>
                        <xsl:text>Facture</xsl:text>
                    </xsl:element>
                </div>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="cm:adresse">
        <address class="card-text">
            <xsl:choose>
                <xsl:when test="count(cm:numero) &gt; 0">
                    <xsl:value-of select="cm:numero"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="cm:rue"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="
                        concat(
                            translate(
                                substring(cm:rue,1,1),
                                $smallcase,
                                $uppercase
                            ),
                            substring(cm:rue,2,string-length(cm:rue)-1)
                        )
                    "/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="cm:codePostal"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="translate(cm:ville,$smallcase,$uppercase)"/>
            <xsl:if test="count(cm:étage) &gt; 0">
                <xsl:text> (&#201;tage </xsl:text>
                <xsl:value-of select="cm:étage"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </address>
    </xsl:template>

    <xsl:template match="cm:acte">
        <xsl:variable name="idActe" select="@id"/>
        <tr>
            <td>
                <xsl:value-of select="$idActe"/>
            </td>
            <td>
                <xsl:choose>
                <xsl:when test="not(.='')">
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($ngap//acte[@id=$idActe])"/>
                </xsl:otherwise>
            </xsl:choose>
            </td>
        </tr>
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