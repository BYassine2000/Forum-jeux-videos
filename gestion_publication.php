<?php 
error_reporting(0);

$unControleur->setTable("publication");
$publicationView = 0;

if (isset($_GET['view'])) {
    $unControleur->setTable("publication");
	if (isset($_GET['delete']) && isset($_GET['idpublication'])) {
		$idpublication = $_GET['idpublication'];
		$unControleur->deletePublication($idpublication);
		$redirection = <<<EOT
		<script type='text/javascript'>window.location.replace("publication");</script>
		EOT;
		echo($redirection);
	}
	
    $publicationView = 1;
    $idpublication = $_GET['view'];
    $where1 = array("idpublication"=>$idpublication);
    $lePublication = $unControleur->selectWhere("*", $where1);
    $unControleur->setTable("client");
    $whereClient = array("idclient"=>$lePublication['idclient']);
    $nomClient = $unControleur->selectWhere("nom", $whereClient);

    // Récupération du nom de l'auteur de la publication
    $unControleur->setTable("auteur");
    $whereAuteur = array("idauteur"=>$lePublication['idauteur']);
    $nomAuteur = $unControleur->selectWhere("nom", $whereAuteur);

    $unControleur->setTable("commentaire");
    $where2 = array("idpublication"=>$idpublication);
    $nbCommentaires = $unControleur->countWhere($where2);
    $unControleur->setTable("vcommentaire");
    $where3 = array("idpublication"=>$idpublication);
    $lesCommentaires = $unControleur->selectAllCommentaires($where3);
    $editCom = null;

	$unControleur->setTable("commentaire");

	if (isset($_GET['action']) && isset($_GET['idcom']) && isset($_GET['idpublication'])) {
		$action = $_GET['action'];
		$idcom = $_GET['idcom'];
		$idpublication2 = $_GET['idpublication'];
		
		switch ($action) {
			case 'delete': // SUPPRESSION DU COMMENTAIRE
				// Si le rôle du client est "admin", on permet la suppression du commentaire sans tenir compte de son idclient
				if ($_SESSION['role'] == 'admin') {
					$where4 = array(
						"idcom" => $idcom, 
						"idpublication" => $idpublication2
					);
				} else {
					$where4 = array(
						"idcom" => $idcom, 
						"idpublication" => $idpublication2, 
						"idclient" => $_SESSION['idclient']
					);
				}
				
				$unControleur->setTable("commentaire");
				$unControleur->delete($where4);
				$redirection = <<<EOT
				<script type='text/javascript'>window.location.replace("publication?view=$idpublication2");</script>
				EOT;
				echo($redirection);
				break;
			case 'edit': // ÉDITION DU COMMENTAIRE
				$where5 = array(
					"idcom" => $idcom, 
					"idpublication" => $idpublication2, 
					"idclient" => $_SESSION['idclient']
				);
				$editCom = $unControleur->selectWhere("*", $where5);
				break;
		}
	}
	
	if (isset($_POST['Edit'])) {
		$unControleur->setTable("commentaire");
		$whereEdit = array(
			"idcom" => $idcom, 
			"idpublication" => $idpublication2, 
			"idclient" => $_SESSION['idclient']
		);
		$tab = array(
			"contenu" => $_POST['contenu'],
			"dateheurepost" => date("Y-m-d H:i:s", strtotime("+1 hour"))
		);
		$unControleur->update($tab, $whereEdit);
		$redirection = <<<EOT
			<script type='text/javascript'>window.location.replace("publication?view=$idpublication2");</script>
		EOT;
		echo($redirection);
	}
	
	if (isset($_POST['Poster'])) {
		$unControleur->setTable("commentaire");
		$tab = array(
			"idpublication" => $idpublication,
			"idclient" => $_SESSION['idclient'],
			"contenu" => $_POST['contenu'],
			"clien_id" => $_SESSION['idclient'],
			"dateheurepost" => date("Y-m-d H:i:s", strtotime("+1 hour"))
		);
		$unControleur->insert($tab);
		$redirection = <<<EOT
		<script type='text/javascript'>window.location.replace("publication?view=$idpublication");</script>
		EOT;
		echo($redirection);
	}
	
}

require_once("vue/publication.php");
?>