/**
 * Supabase Client Utilities
 *
 * Utilidades compartidas para Edge Functions
 */

import { createClient, SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2';

/**
 * Crea un cliente Supabase con service role
 */
export function createServiceClient(): SupabaseClient {
  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error('SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY não configurados');
  }

  return createClient(supabaseUrl, serviceRoleKey);
}

/**
 * Obtiene el usuario autenticado desde el token JWT
 */
export async function getAuthenticatedUser(
  req: Request,
  supabase: SupabaseClient
): Promise<any> {
  const authHeader = req.headers.get('Authorization');

  if (!authHeader) {
    throw new Error('Authorization header não encontrado');
  }

  const token = authHeader.replace('Bearer ', '');
  const { data: { user }, error } = await supabase.auth.getUser(token);

  if (error || !user) {
    throw new Error('Usuário não autenticado');
  }

  return user;
}

/**
 * Crea una respuesta JSON exitosa
 */
export function successResponse(data: any, status: number = 200): Response {
  return new Response(JSON.stringify({ success: true, data }), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

/**
 * Crea una respuesta JSON de error
 */
export function errorResponse(message: string, status: number = 400): Response {
  return new Response(JSON.stringify({ success: false, error: message }), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

/**
 * Valida que los campos requeridos estén presentes
 */
export function validateRequiredFields(data: any, requiredFields: string[]): void {
  const missing = requiredFields.filter((field) => !data[field]);

  if (missing.length > 0) {
    throw new Error(`Campos obrigatórios ausentes: ${missing.join(', ')}`);
  }
}

/**
 * Log helper para Edge Functions
 */
export function logInfo(functionName: string, message: string, data?: any): void {
  console.log(`[${functionName}] ${message}`, data ? JSON.stringify(data) : '');
}

/**
 * Log de erro para Edge Functions
 */
export function logError(functionName: string, error: any): void {
  console.error(`[${functionName}] ERROR:`, error.message || error);
  if (error.stack) {
    console.error(error.stack);
  }
}
