-- Création de la base de données
CREATE DATABASE IF NOT EXISTS moncoinpharma;
USE moncoinpharma;

-- Table des utilisateurs
CREATE TABLE utilisateurs (
    utilisateur_id INT PRIMARY KEY AUTO_INCREMENT,
    prenom VARCHAR(50) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    ville VARCHAR(50),
    code_postal VARCHAR(10),
    role ENUM('client', 'admin', 'pharmacien') DEFAULT 'client',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des catégories
CREATE TABLE categories (
    categorie_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icone VARCHAR(50),
    categorie_parent_id INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categorie_parent_id) REFERENCES categories(categorie_id) ON DELETE SET NULL
);

-- Table des produits
CREATE TABLE produits (
    produit_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    prix DECIMAL(10, 2) NOT NULL,
    prix_promo DECIMAL(10, 2),
    stock INT NOT NULL DEFAULT 0,
    ordonnance_requise BOOLEAN DEFAULT FALSE,
    url_image VARCHAR(255),
    categorie_id INT,
    statut ENUM('actif', 'inactif', 'rupture_stock') DEFAULT 'actif',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categorie_id) REFERENCES categories(categorie_id) ON DELETE SET NULL
);

-- Table des images de produits
CREATE TABLE images_produits (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    produit_id INT NOT NULL,
    url_image VARCHAR(255) NOT NULL,
    est_principale BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE
);

-- Table des commandes
CREATE TABLE commandes (
    commande_id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    statut ENUM('en_attente', 'en_traitement', 'expediee', 'livree', 'annulee') DEFAULT 'en_attente',
    montant_total DECIMAL(10, 2) NOT NULL,
    adresse_livraison TEXT NOT NULL,
    ville_livraison VARCHAR(50) NOT NULL,
    code_postal_livraison VARCHAR(10),
    telephone VARCHAR(20),
    numero_suivi VARCHAR(100),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(utilisateur_id)
);

-- Table des articles de commande
CREATE TABLE articles_commande (
    article_commande_id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT NOT NULL,
    produit_id INT NOT NULL,
    quantite INT NOT NULL,
    prix DECIMAL(10, 2) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (commande_id) REFERENCES commandes(commande_id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id)
);

-- Table des ordonnances
CREATE TABLE ordonnances (
    ordonnance_id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    commande_id INT,
    url_image VARCHAR(255) NOT NULL,
    statut ENUM('en_attente', 'approuvee', 'rejetee') DEFAULT 'en_attente',
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(utilisateur_id),
    FOREIGN KEY (commande_id) REFERENCES commandes(commande_id) ON DELETE SET NULL
);

-- Table du panier
CREATE TABLE panier (
    panier_id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    produit_id INT NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE
);

-- Table des favoris
CREATE TABLE favoris (
    favori_id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    produit_id INT NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE,
    UNIQUE KEY favori_unique (utilisateur_id, produit_id)
);

-- Table des avis
CREATE TABLE avis (
    avis_id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT NOT NULL,
    produit_id INT NOT NULL,
    note INT NOT NULL CHECK (note >= 1 AND note <= 5),
    commentaire TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(utilisateur_id),
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE
);

-- Table des articles de blog
CREATE TABLE articles_blog (
    article_id INT PRIMARY KEY AUTO_INCREMENT,
    titre VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    contenu TEXT NOT NULL,
    url_image VARCHAR(255),
    auteur_id INT NOT NULL,
    statut ENUM('brouillon', 'publie', 'archive') DEFAULT 'brouillon',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (auteur_id) REFERENCES utilisateurs(utilisateur_id)
);

-- Table des promotions
CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL,
    description TEXT,
    pourcentage_reduction DECIMAL(5, 2),
    montant_reduction DECIMAL(10, 2),
    date_debut DATETIME NOT NULL,
    date_fin DATETIME NOT NULL,
    statut ENUM('active', 'inactive', 'expiree') DEFAULT 'active',
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des produits en promotion
CREATE TABLE produits_promotions (
    produit_id INT NOT NULL,
    promotion_id INT NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (produit_id, promotion_id),
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE,
    FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id) ON DELETE CASCADE
);

-- Insertion des catégories par défaut
INSERT INTO categories (nom, slug, description, icone) VALUES
('Médicaments', 'medicaments', 'Médicaments et produits pharmaceutiques', 'fa-pills'),
('Beauté', 'beaute', 'Produits de beauté et soins du corps', 'fa-spa'),
('Bébé & Enfant', 'bebe-enfant', 'Produits pour bébés et enfants', 'fa-baby'),
('Hygiène', 'hygiene', 'Produits d''hygiène personnelle', 'fa-pump-soap'),
('Sport & Nutrition', 'sport-nutrition', 'Produits pour le sport et la nutrition', 'fa-running'),
('Naturel & Bio', 'naturel-bio', 'Produits naturels et biologiques', 'fa-leaf'),
('Vitamines', 'vitamines', 'Vitamines et compléments alimentaires', 'fa-capsules'),
('Matériel Médical', 'materiel-medical', 'Équipement et matériel médical', 'fa-stethoscope');

-- Insertion de l'utilisateur administrateur
INSERT INTO utilisateurs (prenom, nom, email, mot_de_passe, role) VALUES
('Admin', 'Système', 'admin@moncoinpharma.dz', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'); 