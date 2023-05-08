<?php
// Vérifier si un fichier a été téléchargé
if (isset($_FILES['imagepublication'])) {
    // Vérifier s'il y a eu une erreur lors du téléchargement
    if ($_FILES['imagepublication']['error'] == UPLOAD_ERR_OK) {
        // Récupérer le nom du fichier
        $nomFichier = $_FILES['imagepublication']['name'];
        // Récupérer le chemin temporaire du fichier
        $cheminTemporaire = $_FILES['imagepublication']['tmp_name'];
        // Définir le chemin de destination
        $cheminDestination = 'D:\wamp64\www\JVI\assets\images\publications\\' . $nomFichier;
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
?>
