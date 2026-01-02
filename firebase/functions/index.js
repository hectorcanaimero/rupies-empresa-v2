const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Importar webhooks de Supabase
const supabaseWebhooks = require("./supabase_webhooks");

// Exportar función de nuevo servicio
exports.onNewServiceCreated = supabaseWebhooks.onNewServiceCreated;
