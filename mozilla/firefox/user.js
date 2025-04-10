// ─────────────────────────────────────
// 🌐 Interface et comportement
// ─────────────────────────────────────

// Désactiver l'ouverture du menu avec ALT
user_pref("ui.key.menuAccessKeyFocuses", false);

// Empêche Firefox de demander s'il est le navigateur par défaut
user_pref("browser.shell.checkDefaultBrowser", false);

// Désactiver les suggestions de moteurs de recherche
user_pref("browser.urlbar.suggest.engines", false);

// Empêcher les suggestions de sites populaires
user_pref("browser.urlbar.suggest.topsites", false);

// Activer le smooth scrolling
user_pref("general.smoothScroll", true);

// Désactiver l'animation de nouvel onglet (plus rapide)
user_pref("browser.tabs.animate", false);

// Toujours ouvrir les liens dans un nouvel onglet (pas nouvelle fenêtre)
user_pref("browser.link.open_newwindow", 3);

// Ne jamais ouvrir une nouvelle fenêtre sans l'utilisateur
user_pref("browser.link.open_newwindow.restriction", 0);

// Empêcher les popups de voler le focus
user_pref("dom.disable_window_flip", true);


// ─────────────────────────────────────
// 🔒 Vie privée légère sans casser les sites
// ─────────────────────────────────────

// Do Not Track
user_pref("privacy.donottrackheader.enabled", true);

// Désactiver la suggestion de contenu sponsorisé
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Supprimer les recommandations dans les paramètres
user_pref("browser.preferences.moreFromMozilla", false);

// ─────────────────────────────────────
// ⚙️ Performances & compatibilité Linux
// ─────────────────────────────────────

// Désactiver la mise à jour automatique (gérée via package manager)
user_pref("app.update.auto", false);
user_pref("app.update.enabled", false);
