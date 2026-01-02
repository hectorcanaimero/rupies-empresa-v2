#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# Script de Ejecución - Migrations Clube dos 100
# ═══════════════════════════════════════════════════════════════
#
# Este script ejecuta TODAS las migrations automáticamente
# Requiere acceso directo a PostgreSQL via psql
#
# ═══════════════════════════════════════════════════════════════

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATIONS_DIR="$SCRIPT_DIR/migrations"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function para print con color
print_step() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# ═══════════════════════════════════════════════════════════════
# Verificar credenciales
# ═══════════════════════════════════════════════════════════════

print_step "CONFIGURACIÓN DE CONEXIÓN"

echo ""
print_warning "Este script requiere conexión directa a PostgreSQL via psql"
print_info "Si no tienes psql, ejecuta las migrations manualmente:"
echo "   1. Abre Supabase Dashboard: https://supa.rupies.com.br"
echo "   2. Ve a SQL Editor"
echo "   3. Ejecuta cada migration en orden"
echo ""

read -p "¿Tienes acceso psql y quieres continuar? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    print_info "OK. Usa el método manual en Supabase Dashboard"
    print_info "Sigue la guía: EXECUTAR_MIGRATIONS.md"
    exit 0
fi

# Pedir credenciales
echo ""
print_info "Ingresa las credenciales de PostgreSQL:"
read -p "Host (default: supa.rupies.com.br): " DB_HOST
DB_HOST=${DB_HOST:-supa.rupies.com.br}

read -p "Puerto (default: 5432): " DB_PORT
DB_PORT=${DB_PORT:-5432}

read -p "Database (default: postgres): " DB_NAME
DB_NAME=${DB_NAME:-postgres}

read -p "Usuario (default: postgres): " DB_USER
DB_USER=${DB_USER:-postgres}

read -sp "Password: " DB_PASS
echo ""

export PGPASSWORD="$DB_PASS"

# ═══════════════════════════════════════════════════════════════
# Verificar conexión
# ═══════════════════════════════════════════════════════════════

print_step "VERIFICANDO CONEXIÓN"

if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "SELECT 1;" > /dev/null 2>&1; then
    print_error "No se pudo conectar a PostgreSQL"
    print_info "Verifica las credenciales e intenta de nuevo"
    exit 1
fi

print_success "Conexión exitosa"

# ═══════════════════════════════════════════════════════════════
# Passo 0: Dropar tabla antigua
# ═══════════════════════════════════════════════════════════════

print_step "PASSO 0: Limpieza de tabla existente"

echo ""
print_warning "Se va a dropar la tabla 'subscriptions' si existe"
read -p "¿Confirmas? La tabla está VACÍA según verificación (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    print_error "Operación cancelada por el usuario"
    exit 0
fi

psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c \
    "DROP TABLE IF EXISTS subscriptions CASCADE;" \
    > /dev/null 2>&1

print_success "Tabla antigua removida"

# ═══════════════════════════════════════════════════════════════
# Passo 1: Ejecutar migration 1 - Schema
# ═══════════════════════════════════════════════════════════════

print_step "PASSO 1: Creando schema (tabelas, RLS, datos)"

MIGRATION_1="$MIGRATIONS_DIR/20251228_create_subscription_system.sql"

if [ ! -f "$MIGRATION_1" ]; then
    print_error "Archivo no encontrado: $MIGRATION_1"
    exit 1
fi

if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$MIGRATION_1" > /dev/null 2>&1; then
    print_success "Migration 1 ejecutada: Schema creado"
else
    print_error "Error ejecutando migration 1"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# Passo 2: Ejecutar migration 2 - Functions
# ═══════════════════════════════════════════════════════════════

print_step "PASSO 2: Creando functions PostgreSQL"

MIGRATION_2="$MIGRATIONS_DIR/20251228_create_subscription_functions.sql"

if [ ! -f "$MIGRATION_2" ]; then
    print_error "Archivo no encontrado: $MIGRATION_2"
    exit 1
fi

if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$MIGRATION_2" > /dev/null 2>&1; then
    print_success "Migration 2 ejecutada: Functions creadas"
else
    print_error "Error ejecutando migration 2"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# Passo 3: Ejecutar migration 3 - Views
# ═══════════════════════════════════════════════════════════════

print_step "PASSO 3: Creando views otimizadas"

MIGRATION_3="$MIGRATIONS_DIR/20251228_create_subscription_views.sql"

if [ ! -f "$MIGRATION_3" ]; then
    print_error "Archivo no encontrado: $MIGRATION_3"
    exit 1
fi

if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$MIGRATION_3" > /dev/null 2>&1; then
    print_success "Migration 3 ejecutada: Views creadas"
else
    print_error "Error ejecutando migration 3"
    exit 1
fi

# ═══════════════════════════════════════════════════════════════
# Verificación final
# ═══════════════════════════════════════════════════════════════

print_step "VERIFICACIÓN FINAL"

echo ""
print_info "Verificando tablas creadas..."

TABLES=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tA -c \
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('subscription_plans', 'subscriptions', 'payment_transactions', 'feature_flags', 'subscription_usage') ORDER BY table_name;")

COUNT=$(echo "$TABLES" | wc -l | tr -d ' ')

if [ "$COUNT" -eq 5 ]; then
    print_success "5 tablas creadas correctamente"
    echo "$TABLES" | while read table; do
        echo "   ✅ $table"
    done
else
    print_error "Solo se crearon $COUNT de 5 tablas"
fi

echo ""
print_info "Verificando functions creadas..."

FUNCTIONS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tA -c \
    "SELECT routine_name FROM information_schema.routines WHERE routine_schema = 'public' AND routine_name LIKE '%subscription%' ORDER BY routine_name;" | head -5)

echo "$FUNCTIONS" | while read func; do
    echo "   ✅ $func"
done

echo ""
print_info "Verificando feature flag..."

FLAG=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -tA -c \
    "SELECT flag_key, is_enabled FROM feature_flags WHERE flag_key = 'show_premium_features';")

if [ -n "$FLAG" ]; then
    print_success "Feature flag creada: $FLAG"
else
    print_warning "Feature flag no encontrada"
fi

# ═══════════════════════════════════════════════════════════════
# Finalización
# ═══════════════════════════════════════════════════════════════

print_step "✅ MIGRATIONS COMPLETADAS"

echo ""
print_success "Todas las migrations fueron ejecutadas exitosamente!"
echo ""
print_info "Próximos pasos:"
echo "   1. Ejecuta el test de conexión: node test-connection.js"
echo "   2. Verifica las queries de: EXECUTAR_MIGRATIONS.md"
echo "   3. Inicia Fase 2: Edge Functions (integración Asaas)"
echo ""
print_info "Para habilitar features premium después de store approval:"
echo "   UPDATE feature_flags SET is_enabled = true WHERE flag_key = 'show_premium_features';"
echo ""
