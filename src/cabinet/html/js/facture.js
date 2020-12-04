var AMIVAL = 3.15;
var AISVAL = 2.65;
var DIVAL = 10.0;

var totalFacture = 0.0;

function afficherFacture(prenom, nom, actes)
{
    totalFacture = 0.0;
    var text = "<!DOCTYPE html>\n<html>\n";
    text +=
            "    <head>\n\
            <title>Facture</title>\n\
            <link rel='stylesheet' type='text/css' href='css/mystyle.css'/>\n\
         </head>\n\
         <body>\n";


    text += "Facture pour " + prenom + " " + nom + "<br/>";


    // Trouver l'adresse du patient
    var xmlDoc = loadXMLDoc("../xml/data/cabinet.xml");
    var patients = xmlDoc.getElementsByTagName("patient");
    var i = 0;
    var found = false;

    while ((i < patients.length) && (!found)) {
        var patient = patients[i];
        var localNom = patient.getElementsByTagName("nom")[0].childNodes[0].nodeValue;
        var localPrenom = patient.getElementsByTagName("prénom")[0].childNodes[0].nodeValue;
        if ((nom === localNom) && (prenom === localPrenom)) {
            found = true;
        }
        else {
            i++;
        }
    }


    if (found) {
        let patient = patients[i];
        text += "Adresse: ";
        // On récupère l'adresse du patient
        var adresse = patient.getElementsByTagName('adresse')[0];
        // adresse = ... à compléter par une expression DOM
        text += adresseToText(adresse);
        text += "<br/>";

        var nSS = patient.getElementsByTagName('numéro')[0].textContent; // Le premier numéro est toujours le NSS.
        // nss = récupérer le numéro de sécurité sociale grâce à une expression DOM

        text += "Numéro de sécurité sociale: " + nSS + "\n";
    }
    text += "<br/>";



    // Tableau récapitulatif des Actes et de leur tarif
    text += "<table border='1'  bgcolor='#CCCCCC'>";
    text += "<tr>";
    text += "<td> Type </td> <td> Clé </td> <td> Intitulé </td> <td> Coef </td> <td> Tarif </td>";
    text += "</tr>";

    var acteIds = actes.split(" ");
    for (var j = 0; j < acteIds.length; j++) {
        text += "<tr>";
        var acteId = acteIds[j];
        text += acteTable(acteId);
        text += "</tr>";
    }
    
     text += "<tr><td colspan='4'>Total</td><td>" + totalFacture + "</td></tr>\n";
     
     text +="</table>";
     
     
    text +=
            "    </body>\n\
    </html>\n";
    
    // Préparation de la fenêtre d'affichage.
    var width  = 500;
    var height = 300;
    if(window.innerWidth) {
        var left = (window.innerWidth-width)/2;
        var top = (window.innerHeight-height)/2;
    }
    else {
        var left = (document.body.clientWidth-width)/2;
        var top = (document.body.clientHeight-height)/2;
    }
    var factureWindow = window.open('','Facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
    factureWindow.document.write(text);

    return text;
}

// Mise en forme d'un noeud adresse pour affichage en html
function adresseToText(adresse)
{
    let adrElts = adresse.children;
    var str = "<address>\n";
    let etg = "", rue = "", ville = "";
    // Mise en forme de l'adresse du patient
    for (let i = 0; i < adrElts.length; i++) {
        let e = adrElts[i];
        switch (e.localName) {
            case "étage":
                etg = "Etage "+e.textContent+"<br/>";
                break;
            case "numéro":
                rue = e.textContent+", ";
                break;
            case "rue":
                if (rue === "") rue += e.textContent.charAt(0).toUpperCase()+e.textContent.toString().substring(1);
                else rue += e.textContent;
                rue += "<br/>";
                break;
            case "ville":
                ville = e.textContent.toUpperCase()+"<br/>";
                break;
            case "codePostal":
                ville = e.textContent+" "+ville;
            default:
                break;
        }
    }
    str += rue+ville+etg;
    str += "</adress>";
    return str;
}


function acteTable(acteId)
{
    var str = "";

    var xmlDoc = loadXMLDoc("../xml/data/actes.xml");
    
    // var actes = xmlDoc.getElementsByTagName('acte');
    // actes = récupérer les actes de xmlDoc
    /* 
     * Inutile ici, on peut récupérer l'acte en question directement par ID.
     * Les IDs des actes et des types sont différents, donc il n'y aura pas de conflit.
     */
    
    let acte = xmlDoc.getElementById(acteId);
    
    // Clé de l'acte (3 lettres)
    var cle = acte.getAttribute('clé');
    // Coef de l'acte (nombre)
    var coef = parseFloat(acte.getAttribute('coef'));
    // Type id pour pouvoir récupérer la chaîne de caractères du type 
    //  dans les sous-éléments de types
    var typeId = acte.getAttribute('type');
    // Chaîne de caractère du type
    var type = xmlDoc.getElementById(typeId).textContent;
    // ...
    // Intitulé de l'acte
    var intitule = acte.textContent.trim();

    // Tarif = (lettre-clé)xcoefficient (utiliser les constantes 
    // var AMIVAL = 3.15; var AISVAL = 2.65; et var DIVAL = 10.0;)
    // (cf  http://www.infirmiers.com/votre-carriere/ide-liberale/la-cotation-des-actes-ou-comment-utiliser-la-nomenclature.html)
    var tarif = 0.0;
    switch (cle) {
        case "AMI": tarif += AMIVAL; break;
        case "AIS": tarif += AISVAL; break;
        case "DI": tarif += DIVAL; break;
        default: break;
    }
    tarif *= coef;

    // A modifier
    str += "<td>" + type + "</td>";
    str += "<td>" + cle + "</td>";
    str += "<td>" + intitule + "</td>";
    str += "<td>" + coef + "</td>";
    str += "<td>" + tarif + "</td>";
    totalFacture += tarif;

    return str;
}


// Fonction qui charge un document XML
function loadXMLDoc(docName)
{
    var xmlhttp;
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    } else
    {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.overrideMimeType("text/xml");
    xmlhttp.open("GET", docName, false);
    xmlhttp.send();
    xmlDoc = xmlhttp.responseXML;

    return xmlDoc;
}
