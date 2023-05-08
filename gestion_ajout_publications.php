<?php

$unControleur->setTable("type");
$lesTypes = $unControleur->selectAll("*");

$publicationsParPage = 8;

$publicationsTotales = $unControleur->getIdPublication();

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

} else {
    $lesPublications = $unControleur->selectAllPublications($depart, $publicationsParPage);
}

if (isset($_POST['Valider'])) {
    $idtype = $_POST['idtype'];
    $tab = array("idtype");
    $lesPublications = $unControleur->selectSearch($idtype, $tab);
}

if (isset($_FILES['imagepublication'])) {
    // Vérifier s'il y a eu une erreur lors du téléchargement
    if ($_FILES['imagepublication']['error'] == UPLOAD_ERR_OK) {
        // Récupérer le nom du fichier
        $nomFichier = $_FILES['imagepublication']['name'];
        // Récupérer le chemin temporaire du fichier
        $cheminTemporaire = $_FILES['imagepublication']['tmp_name'];
        // Définir le chemin de destination
        $cheminDestination = 'assets\images\publications\\' . $nomFichier;
        // Déplacer le fichier vers le répertoire de destination
        if (move_uploaded_file($cheminTemporaire, $cheminDestination)) {
            // Le fichier a été téléchargé avec succès
            echo "Le fichier a été téléchargé avec succès !";
        } else {
            // Il y a eu une erreur lors du déplacement du fichier
            echo "Erreur : impossible de déplacer le fichier !";
        }
    } else {
        // Il y a eu une erreur lors du téléchargement du fichier
        echo "Erreur : le fichier n'a pas été téléchargé !";
    }
}

if (isset($_POST['ajouterPublication'])) {
    $unControleur->setTable('publication');
    $idclient = $_SESSION['idclient'];
    $nompublication = $_POST['nompublication'];
    $descriptionpublication = $_POST['descriptionpublication'];
    $imagepublication = $_FILES['imagepublication']['name']; // récupérer le nom de l'image envoyée
    $idtype = $_POST['idtype'];    
    $tab = array(
        'idclient' => $idclient,
        'nompublication' => $nompublication,
        'imagepublication' => $imagepublication,
        'descriptionpublication' => $descriptionpublication,
        'idtype' => $idtype,
        'date_ajout' => date("Y-m-d H:i:s")
    );

    if (empty(trim($_POST['nompublication'])) || empty(trim($_POST['descriptionpublication'])) || empty($_POST['idtype']) || empty($_FILES['imagepublication']['name'])) {
        echo '<script>alert("Veuillez remplir tous les champs du formulaire !");</script>';
    } else {
        $unControleur->insert($tab);
        echo '<script language="javascript">document.location.replace("ajout_publication");</script>';
    }
}

require_once("vue/ajout_publication.php");

?>