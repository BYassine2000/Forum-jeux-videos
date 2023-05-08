<?php

$total = 0;

if (isset($_SESSION['idclient'])) {
	$unControleur->setTable("vpanier");
	$where = array("idclient"=>$_SESSION['idclient']);
	$lesPaniers = $unControleur->selectAllByPanier($where);
}

if (isset($_GET['action']) && isset($_GET['numcommande']) && isset($_GET['idpublication']) && isset($_GET['idclient'])) {
    $action = $_GET['action'];
    $numcommande = $_GET['numcommande'];
    $idpublication = $_GET['idpublication'];
    $idclient = $_GET['idclient'];
    $tab = array("numcommande"=>$numcommande, "idpublication"=>$idpublication, "idclient"=>$idclient);
    switch ($action) {
        case 'sup': 
            $unControleur->appelProc("deleteCommande", $tab);
           	echo '<script language="javascript">document.location.replace("panier");</script>';
            break;
    }
}

if (isset($_POST['ModifierQte'])) {

	// Vérifier la quantité disponible du publication
	$unControleur->setTable("publication");
	$where = array("idpublication"=>$_POST['idpublication']);
	$unPublication = $unControleur->selectWhere("*", $where);

	// Si la quantité du publication >= à la quantité souhaité
	if ($unPublication['qtepublication'] >= $_POST['quantite']) {
		$unControleur->setTable("panier");
		$tab = array("quantite"=>$_POST['quantite']);
		$where = array("idpublication"=>$_POST['idpublication'], "idclient"=>$_SESSION['idclient']);
		$unPanier = $unControleur->selectWhere("*", $where);
		$unControleur->update($tab, $where);
		echo '<script language="javascript">document.location.replace("panier");</script>';

		// Mise à jour de la quantité en stock dans la bdd
		$unControleur->setTable("publication");
		$qte = $unPublication['qtepublication'] + ($unPanier['quantite'] - $_POST['quantite']);
		$tab = array("qtepublication"=>$qte);
		$where = array("idpublication"=>$_POST['idpublication']);
		$unControleur->update($tab, $where);
	} else {
		$erreur = "Pas assez de stock.";
	}

}

/* SAVE
if (isset($_POST['ModifierQte'])) {

	// Vérifier la quantité disponible du publication
	$unControleur->setTable("publication");
	$where = array("idpublication"=>$_POST['idpublication']);
	$unPublication = $unControleur->selectWhere("*", $where);

	// Si la quantité du publication >= à la quantité souhaité
	if ($unPublication['qtepublication'] >= $_POST['quantite']) {
		$unControleur->setTable("panier");
		$tab = array("quantite"=>$_POST['quantite']);
		$where = array("idpublication"=>$_POST['idpublication'], "idclient"=>$_SESSION['idclient']);
		$unControleur->update($tab, $where);
		echo '<script language="javascript">document.location.replace("panier");</script>';
	} else {
		$erreur = "Pas assez de stock.";
	}

}
*/

if (isset($_POST['payement'])) {

	$unControleur->setTable("panier");
	$lesPaniers = $unControleur->selectAll("*");

	foreach ($lesPaniers as $unPanier) {
		
		$idclient = $unPanier['idclient'];
		$idpublication = $unPanier['idpublication'];
		$numcommande = $unPanier['numcommande'];

		// Mise à jour des informations de la commande
		$unControleur->setTable("savecommande");
		$where1 = array("idclient"=>$idclient, "idpublication"=>$idpublication);
		$tab1 = array(
			"mode_payement"=>$_POST['mode_payement'],
			"etat"=>'En cours de preparation...'
		);
		$unControleur->update($tab1, $where1);

		// Recherche numcommande de la commande
		$uneSaveCommande = $unControleur->selectWhere("*", $where1);
		$numcommandeSave = $uneSaveCommande['numcommande'];

		// Insertion dans la table facture
		$unControleur->setTable("facture");
		$tab2 = array(
			"idclient"=>$idclient,
			"idpublication"=>$idpublication,
			"numcommande"=>$numcommandeSave,
			"quantite"=>$unPanier['quantite']
		);
		$unControleur->appelProc("insertFacture", $tab2);

		$unControleur->setTable("commande");
		$tab3 = array(
			"numcommande"=>$numcommande,
			"idpublication"=>$idpublication,
			"idclient"=>$idclient
		);
		$unControleur->appelProc("deleteCommande", $tab3);
	}

	// Email pour confirmer l'achat du client
	$header = "MIME-Version: 1.0\r\n";
	$header .= 'From: "JVI"<EMAIL_DU_COMPTE_NON_SECURISE>'."\n"; // Voir dossier 'sendmail'
	$header .= 'Content-Type:text/html; charset=utf-8"'."\n";
	$header .= 'Content-Transfer-Encoding: 8bit';

	$email = $_SESSION['email'];

	$message = '
<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<body>
<div role="article" aria-roledescription="email" aria-label="Verify Email Address" lang="en">
    <table style="font-family: Montserrat, -apple-system, "Segoe UI", sans-serif; width: 100%;" width="100%" cellpadding="0" cellspacing="0" role="presentation">
        <tr>
            <td align="center" style="--bg-opacity: 1; font-family: Montserrat, -apple-system, "Segoe UI", sans-serif;">
                <table class="sm-w-full" style="font-family: "Montserrat", Arial, sans-serif; width: 600px;" width="600" cellpadding="0" cellspacing="0" role="presentation">
                    <tr>
                        <td align="center" class="sm-px-24" style="font-family: "Montserrat", Arial, sans-serif;">
                            <table style="font-family: "Montserrat", Arial, sans-serif; width: 600px;" width="600" cellpadding="0" cellspacing="0" role="presentation">
                                <tr>
                                    <td class="sm-px-24" style="--bg-opacity: 1; background-color: rgb(24, 26, 27); font-family: Montserrat, -apple-system, "Segoe UI", sans-serif; font-size: 14px; line-height: 24px; padding: 48px; text-align: left; --text-opacity: 1; color: #626262; color: rgba(98, 98, 98, var(--text-opacity));" bgcolor="rgba(255, 255, 255, var(--bg-opacity))" align="left">
                                        <p style="font-weight: 600; font-size: 18pt; margin-bottom: 0; color: #f8f9fa!important; text-align: center;">
                                        	<style type="text/css">.ii a[href] {color: aqua!important;}</style>
                                            Bonjour, 
                                        </p>
                                        <p class="sm-leading-32" style="font-weight: 600; font-size: 20px; margin: 0 0 16px; --text-opacity: 1; color: #263238; margin-top: 5%; color: #f8f9fa!important; text-align: center;">
                                            Nous avons bien reçu votre commande.
                                        </p><br>
                                        <p class="sm-leading-32" style="font-weight: 600; font-size: 20px; margin: 0 0 16px; --text-opacity: 1; color: #263238; margin-top: 5%; color: #f8f9fa!important; text-align: center;">
                                            À bientôt !
                                        </p><br>
                                        <table style="font-family: "Montserrat",Arial,sans-serif; width: 100%;" width="100%" cellpadding="0" cellspacing="0" role="presentation">
                                            <tr>
                                                <td style="font-family: "Montserrat",Arial,sans-serif; padding-top: 32px; padding-bottom: 32px;">
                                                    <div style="--bg-opacity: 1; background-color: #eceff1; background-color: rgba(236, 239, 241, var(--bg-opacity)); height: 1px; line-height: 1px;"></div>
                                                </td>
                                            </tr>
                                        </table>
                                        <p style="margin: 0 0 16px; text-align: center; color: #f8f9fa!important;">
                                            Ceci est un mail automatique, merci de ne pas répondre.
                                        </p>
                                    </td>
                                </tr>
                            <tr>
                            <td style="font-family: "Montserrat",Arial,sans-serif; height: 20px;" height="20"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
</tr>
</table>
</div>
</body>
</html>
';
							
	// mail($email, "Nouvel achat", $message, $header);

	echo '<script language="javascript">document.location.replace("commandes");</script>';

}

require_once("vue/panier.php");

?>
