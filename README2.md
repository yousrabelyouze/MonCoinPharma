# Mon Coin Pharma - Guide d'Implémentation Spring Boot

## Structure du Projet Spring Boot

```
mon-coin-pharma/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── moncoinpharma/
│   │   │           ├── config/
│   │   │           │   ├── SecurityConfig.java
│   │   │           │   ├── WebConfig.java
│   │   │           │   └── BotpressConfig.java
│   │   │           ├── controller/
│   │   │           │   ├── HomeController.java
│   │   │           │   ├── ProductController.java
│   │   │           │   ├── CartController.java
│   │   │           │   ├── UserController.java
│   │   │           │   ├── AdminController.java
│   │   │           │   ├── BlogController.java
│   │   │           │   └── ChatbotController.java
│   │   │           ├── model/
│   │   │           │   ├── Product.java
│   │   │           │   ├── Category.java
│   │   │           │   ├── User.java
│   │   │           │   ├── Order.java
│   │   │           │   ├── OrderItem.java
│   │   │           │   ├── BlogPost.java
│   │   │           │   └── ChatMessage.java
│   │   │           ├── repository/
│   │   │           │   ├── ProductRepository.java
│   │   │           │   ├── CategoryRepository.java
│   │   │           │   ├── UserRepository.java
│   │   │           │   ├── OrderRepository.java
│   │   │           │   └── BlogPostRepository.java
│   │   │           ├── service/
│   │   │           │   ├── ProductService.java
│   │   │           │   ├── UserService.java
│   │   │           │   ├── OrderService.java
│   │   │           │   ├── CartService.java
│   │   │           │   └── ChatbotService.java
│   │   │           └── MonCoinPharmaApplication.java
│   │   └── resources/
│   │       ├── static/
│   │       │   ├── css/
│   │       │   ├── js/
│   │       │   └── images/
│   │       ├── templates/
│   │       └── application.properties
│   └── test/
└── pom.xml
```

## Modèles (Entities)

### 1. Product.java
```java
@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String description;
    private BigDecimal price;
    private Integer stock;
    private String imageUrl;
    
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
    
    private boolean isPrescription;
    private boolean isAvailable;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Getters, Setters, Constructors
}
```

### 2. Category.java
```java
@Entity
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String description;
    private String icon;
    
    @OneToMany(mappedBy = "category")
    private List<Product> products;
    
    // Getters, Setters, Constructors
}
```

### 3. User.java
```java
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String email;
    private String password;
    private String phone;
    private String address;
    
    @Enumerated(EnumType.STRING)
    private UserRole role;
    
    @OneToMany(mappedBy = "user")
    private List<Order> orders;
    
    @ManyToMany
    @JoinTable(
        name = "user_favorites",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "product_id")
    )
    private List<Product> favorites;
    
    // Getters, Setters, Constructors
}
```

### 4. Order.java
```java
@Entity
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;
    
    private BigDecimal totalAmount;
    private String status;
    private String shippingAddress;
    private String paymentMethod;
    private LocalDateTime orderDate;
    
    // Getters, Setters, Constructors
}
```

### 5. OrderItem.java
```java
@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
    
    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    
    private Integer quantity;
    private BigDecimal price;
    
    // Getters, Setters, Constructors
}
```

### 6. BlogPost.java
```java
@Entity
@Table(name = "blog_posts")
public class BlogPost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String content;
    private String author;
    private String imageUrl;
    private LocalDateTime publishedDate;
    private String category;
    
    // Getters, Setters, Constructors
}
```

## Contrôleurs

### 1. HomeController.java
```java
@Controller
public class HomeController {
    @Autowired
    private ProductService productService;
    
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("featuredProducts", productService.getFeaturedProducts());
        model.addAttribute("categories", productService.getAllCategories());
        return "index";
    }
}
```

### 2. ProductController.java
```java
@Controller
@RequestMapping("/products")
public class ProductController {
    @Autowired
    private ProductService productService;
    
    @GetMapping
    public String listProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "products/list";
    }
    
    @GetMapping("/{id}")
    public String viewProduct(@PathVariable Long id, Model model) {
        model.addAttribute("product", productService.getProductById(id));
        return "products/view";
    }
}
```

### 3. CartController.java
```java
@Controller
@RequestMapping("/cart")
public class CartController {
    @Autowired
    private CartService cartService;
    
    @PostMapping("/add")
    public String addToCart(@RequestParam Long productId, @RequestParam Integer quantity) {
        cartService.addToCart(productId, quantity);
        return "redirect:/cart";
    }
    
    @GetMapping
    public String viewCart(Model model) {
        model.addAttribute("cart", cartService.getCart());
        return "cart/view";
    }
}
```

### 4. UserController.java
```java
@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    
    @GetMapping("/login")
    public String showLoginForm() {
        return "user/login";
    }
    
    @PostMapping("/login")
    public String processLogin(@ModelAttribute User user) {
        // Authentication logic
        return "redirect:/";
    }
    
    @GetMapping("/register")
    public String showRegisterForm() {
        return "user/register";
    }
}
```

### 5. AdminController.java
```java
@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {
    @Autowired
    private ProductService productService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private UserService userService;
    
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("stats", orderService.getDashboardStats());
        return "admin/dashboard";
    }
    
    @GetMapping("/products")
    public String manageProducts(Model model) {
        model.addAttribute("products", productService.getAllProducts());
        return "admin/products";
    }
}
```

### 6. BlogController.java
```java
@Controller
@RequestMapping("/blog")
public class BlogController {
    @Autowired
    private BlogPostRepository blogPostRepository;
    
    @GetMapping
    public String listPosts(Model model) {
        model.addAttribute("posts", blogPostRepository.findAll());
        return "blog/list";
    }
    
    @GetMapping("/{id}")
    public String viewPost(@PathVariable Long id, Model model) {
        model.addAttribute("post", blogPostRepository.findById(id).orElseThrow());
        return "blog/view";
    }
}
```

### 7. ChatbotController.java
```java
@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {
    @Autowired
    private ChatbotService chatbotService;
    
    @PostMapping("/message")
    public ResponseEntity<ChatMessage> processMessage(@RequestBody ChatMessage message) {
        return ResponseEntity.ok(chatbotService.processMessage(message));
    }
}
```

## Configuration

### 1. SecurityConfig.java
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/admin/**").hasRole("ADMIN")
                .antMatchers("/user/**").authenticated()
                .anyRequest().permitAll()
            .and()
            .formLogin()
                .loginPage("/user/login")
                .defaultSuccessUrl("/")
            .and()
            .logout()
                .logoutSuccessUrl("/");
    }
}
```

### 2. WebConfig.java
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}
```

## Dépendances (pom.xml)

```xml
<dependencies>
    <!-- Spring Boot Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- Spring Boot Security -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    
    <!-- Spring Data JPA -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    
    <!-- Thymeleaf -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
    
    <!-- MySQL Driver -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
</dependencies>
```

## Étapes d'Implémentation

1. **Configuration Initiale**
   - Créer le projet Spring Boot avec les dépendances nécessaires
   - Configurer la base de données dans application.properties
   - Mettre en place la sécurité

2. **Implémentation des Modèles**
   - Créer les entités JPA
   - Configurer les relations entre les entités
   - Ajouter les validations

3. **Implémentation des Repositories**
   - Créer les interfaces JPA Repository
   - Ajouter les méthodes personnalisées si nécessaire

4. **Implémentation des Services**
   - Créer les services pour la logique métier
   - Implémenter les transactions
   - Gérer les exceptions

5. **Implémentation des Contrôleurs**
   - Créer les contrôleurs REST et MVC
   - Implémenter les endpoints
   - Gérer les validations

6. **Implémentation des Vues**
   - Convertir les templates HTML en Thymeleaf
   - Intégrer les assets statiques
   - Implémenter la navigation

7. **Tests et Déploiement**
   - Écrire les tests unitaires et d'intégration
   - Configurer le déploiement
   - Mettre en place le monitoring

## Configuration de la Base de Données

```properties
# application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/moncoinpharma
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
```

## Sécurité

1. **Authentification**
   - Implémenter l'authentification par formulaire
   - Gérer les rôles utilisateur
   - Sécuriser les endpoints

2. **Autorisation**
   - Configurer les règles d'accès
   - Gérer les permissions
   - Implémenter CSRF protection

## API REST

1. **Endpoints Produits**
   - GET /api/products
   - GET /api/products/{id}
   - POST /api/products
   - PUT /api/products/{id}
   - DELETE /api/products/{id}

2. **Endpoints Utilisateurs**
   - POST /api/users/register
   - POST /api/users/login
   - GET /api/users/profile
   - PUT /api/users/profile

3. **Endpoints Panier**
   - GET /api/cart
   - POST /api/cart/items
   - PUT /api/cart/items/{id}
   - DELETE /api/cart/items/{id}

## Intégration du Chatbot

1. **Configuration Botpress**
   - Configurer l'API Botpress
   - Implémenter le service d'intégration
   - Gérer les webhooks

2. **Interface Chat**
   - Implémenter l'interface utilisateur
   - Gérer les messages en temps réel
   - Sauvegarder l'historique

## Optimisation des Performances

1. **Caching**
   - Mettre en cache les produits populaires
   - Cacher les catégories
   - Implémenter le cache de session

2. **Optimisation des Requêtes**
   - Utiliser les requêtes optimisées
   - Implémenter la paginationx
   - Gérer les relations lazy

## Monitoring et Logging

1. **Logging**
   - Configurer les logs
   - Implémenter le tracing
   - Gérer les erreurs

2. **Monitoring**
   - Mettre en place les métriques
   - Configurer les alertes
   - Surveiller les performances

## Déploiement

1. **Préparation**
   - Configurer le profil de production
   - Optimiser les ressources
   - Sécuriser les configurations

2. **Déploiement**
   - Préparer le serveur
   - Configurer la base de données
   - Déployer l'application

## Maintenance

1. **Backup**
   - Configurer les sauvegardes automatiques
   - Gérer les restaurations
   - Surveiller l'espace disque

2. **Mises à Jour**
   - Planifier les mises à jour
   - Tester les nouvelles versions
   - Documenter les changements 