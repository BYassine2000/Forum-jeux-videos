<?php if (!isset($_SESSION['idclient'])) {
    header('Location: /JVI/connexion');
    exit();
} ?>
<div class="container mt-4">
	<div class="row d-flex justify-content-center">
		<div class="col-auto">
			<div class="card">
				<div class="card-header">
					<h3 class="text-center">
						Bienvenu sur votre pannel d'ajout de publication :
					</h3>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="container reveal mt-4 mb-5">
	<div class="row align-items-center">
		<div class="col-lg-6 mx-auto">
			<div class="card mb-4">
				<div class="card-header">
					<div class="d-flex justify-content-center">
						<div class="col-auto text-center text-light border rounded bg-primary">
							<h1>&nbsp;Ma publication&nbsp;</h1>
						</div>
					</div>
				</div>
				<?php ?>
				<form method="post" action="" enctype="multipart/form-data">
					<div class="card-body">
						<p class="card-text">
							<b><input type="text" name="nompublication" class="form-control" value="" placeholder="Titre de la publication"></b>
						</p>
						<?php if (isset($_SESSION['idclient'])) { ?>
						<p class="card-text">
							<b><input type="hidden" name="nom" class="form-control" value="<?= $_SESSION['nom']; ?>" placeholder="Nom de l'auteur"></b>
						</p>
						<p class="card-text">
							<b><textarea name="descriptionpublication" id="descriptionpublication" class="form-control" value="" placeholder="Description de la publication"></textarea></b>
						</p>
						<p class="card-text">
							<select name="idtype" class="form-control form-select form-control-lg">
								<?php foreach ($lesTypes as $unType) { ?>
								<option value="<?= $unType['idtype']; ?>">
									<?= $unType['libelle']; ?>
								</option>
								<?php } ?>
							</select>
						</p>
						<p class="card-text">
							<b><input type="file" name="imagepublication" class="form-control"></b>
						</p>
						<?php } ?>
					</div>
					<div class="card-footer">
						<div class="d-flex justify-content-center">
							<button type="submit" name="ajouterPublication" class="btn">
								<span class="input-group-text btn-primary" id="basic-addon2">
									Poster
								</span>
							</button>
						</div>
					</div>
				</form>
				<?php ?>
			</div>
		</div>
	</div>
</div>

<script>
    function showAlert() {
        alert("Veuillez remplir tous les champs du formulaire !");
    }
</script>