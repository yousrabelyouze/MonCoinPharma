// Mobile Menu Toggle
document.addEventListener('DOMContentLoaded', function() {
    const menuButton = document.querySelector('[aria-label="Menu"]');
    const sidebar = document.querySelector('.sidebar');
    
    if (menuButton && sidebar) {
        menuButton.addEventListener('click', function() {
            sidebar.classList.toggle('hidden');
        });
    }
});

// Form Validation
function validateForm(form) {
    const inputs = form.querySelectorAll('input[required]');
    let isValid = true;

    inputs.forEach(input => {
        if (!input.value.trim()) {
            isValid = false;
            input.classList.add('border-red-500');
        } else {
            input.classList.remove('border-red-500');
        }
    });

    return isValid;
}

// Add to Cart Functionality
function addToCart(productId, quantity = 1) {
    // Implementation for adding items to cart
    console.log(`Adding product ${productId} to cart with quantity ${quantity}`);
}

// Remove from Cart Functionality
function removeFromCart(productId) {
    // Implementation for removing items from cart
    console.log(`Removing product ${productId} from cart`);
}

// Update Cart Quantity
function updateCartQuantity(productId, quantity) {
    // Implementation for updating cart quantity
    console.log(`Updating product ${productId} quantity to ${quantity}`);
}

// Toggle Favorites
function toggleFavorite(productId) {
    // Implementation for toggling favorites
    console.log(`Toggling favorite status for product ${productId}`);
}

// Search Functionality
function handleSearch(event) {
    event.preventDefault();
    const searchInput = event.target.querySelector('input[type="text"]');
    const searchTerm = searchInput.value.trim();
    
    if (searchTerm) {
        // Implementation for search
        console.log(`Searching for: ${searchTerm}`);
    }
}

// Initialize Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    // Search form
    const searchForm = document.querySelector('form[role="search"]');
    if (searchForm) {
        searchForm.addEventListener('submit', handleSearch);
    }

    // Add to cart buttons
    const addToCartButtons = document.querySelectorAll('[aria-label="Ajouter au panier"]');
    addToCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.dataset.productId;
            addToCart(productId);
        });
    });

    // Remove from cart buttons
    const removeFromCartButtons = document.querySelectorAll('[aria-label="Supprimer l\'article"]');
    removeFromCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.dataset.productId;
            removeFromCart(productId);
        });
    });

    // Favorite buttons
    const favoriteButtons = document.querySelectorAll('[aria-label="Retirer des favoris"]');
    favoriteButtons.forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.dataset.productId;
            toggleFavorite(productId);
        });
    });
}); 