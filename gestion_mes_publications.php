<?php

$unControleur->setTable("type");
$lesTypes = $unControleur->selectAll("*");

$publicationsParPage = 8;

if (isset($_SESSION['idclient'])) {
    $idclient = $_SESSION['idclient'];
    $publicationsTotales = $unControleur->getIdPublicationByClientId($idclient);
} else {
    $publicationsTotales = $unControleur->getIdPublication();
}

$pagesTotales = ceil($publicationsTotales / $publicationsParPage);

if (isset($_GET['p']) and !empty($_GET['p']) and $_GET['p'] > 0) {
    $_GET['p'] = intval($_GET['p']);
    $pageCourante = $_GET['p'];
} else {
    $pageCourante = 1;
}

$pagePrecedente = $pageCourante - 1;

$pageSuivante = $pageCourante + 1;

$depart = ($pageCourante-1) * $publicationsParPage;

$unControleur->setTable("publication");

if (isset($_POST['Rechercher'])) {
    $mot = $_POST['mot'];
    $tab = array("nompublication");
    $publicationsParPage = 8;
    $lesPublications = $unControleur->selectSearch($mot, $tab);
    if (!$lesPublications) {
        $erreur = "Aucun résultat";
        if (isset($_POST['Refesh'])) {
            header('Location: mes_publications');
        }
    }
} else {
    if (isset($_SESSION['idclient'])) {
        $idclient = $_SESSION['idclient'];
        $lesPublications = $unControleur->selectPublicationsByClientId($depart, $publicationsParPage, $idclient);
    } else {
        $lesPublications = $unControleur->selectAllPublications($depart, $publicationsParPage);
    }
    // Ajout de la récupération du nom de l'auteur pour chaque publication
    foreach ($lesPublications as &$publication) {
        $nomAuteur = $unControleur->getNomAuteurPublication($publication['idclient']);
        $publication['nom_auteur'] = $nomAuteur;
    }
}

if (isset($_POST['Valider'])) {
    $idtype = $_POST['idtype'];
    $tab = array("idtype");
    $lesPublications = $unControleur->selectSearch($idtype, $tab);
}

require_once("vue/mes_publications.php");

?>

