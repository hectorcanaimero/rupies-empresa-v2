/**
 * Asaas API Client
 *
 * Utilidades compartidas para integración con la API de Asaas
 * Documentación: https://docs.asaas.com/reference
 */

const ASAAS_API_URL = 'https://www.asaas.com/api/v3';
const ASAAS_SANDBOX_URL = 'https://sandbox.asaas.com/api/v3';

/**
 * Obtiene la URL base de Asaas según el entorno
 */
function getAsaasBaseUrl(): string {
  const isProduction = Deno.env.get('ASAAS_ENVIRONMENT') === 'production';
  return isProduction ? ASAAS_API_URL : ASAAS_SANDBOX_URL;
}

/**
 * Obtiene la API key de Asaas
 */
function getAsaasApiKey(): string {
  const apiKey = Deno.env.get('ASAAS_API_KEY');
  if (!apiKey) {
    throw new Error('ASAAS_API_KEY não configurado');
  }
  return apiKey;
}

/**
 * Headers padrão para requisições Asaas
 */
function getAsaasHeaders(): HeadersInit {
  return {
    'access_token': getAsaasApiKey(),
    'Content-Type': 'application/json',
  };
}

/**
 * Interface para dados do cliente Asaas
 */
export interface AsaasCustomerData {
  name: string;
  email: string;
  cpfCnpj: string;
  phone?: string;
  mobilePhone?: string;
  address?: string;
  addressNumber?: string;
  complement?: string;
  province?: string;
  postalCode?: string;
  externalReference?: string;
  notificationDisabled?: boolean;
}

/**
 * Interface para dados de assinatura Asaas
 */
export interface AsaasSubscriptionData {
  customer: string; // ID do cliente Asaas
  billingType: 'BOLETO' | 'CREDIT_CARD' | 'PIX' | 'UNDEFINED';
  value: number;
  nextDueDate: string; // YYYY-MM-DD
  cycle: 'WEEKLY' | 'BIWEEKLY' | 'MONTHLY' | 'QUARTERLY' | 'SEMIANNUALLY' | 'YEARLY';
  description?: string;
  endDate?: string; // YYYY-MM-DD
  maxPayments?: number;
  externalReference?: string;
}

/**
 * Interface para dados de cobrança Asaas
 */
export interface AsaasPaymentData {
  customer: string;
  billingType: 'BOLETO' | 'CREDIT_CARD' | 'PIX' | 'UNDEFINED';
  value: number;
  dueDate: string; // YYYY-MM-DD
  description?: string;
  externalReference?: string;
  installmentCount?: number;
  installmentValue?: number;
}

/**
 * Cria ou atualiza um cliente no Asaas
 */
export async function createOrUpdateAsaasCustomer(
  customerData: AsaasCustomerData,
  customerId?: string
): Promise<any> {
  const url = customerId
    ? `${getAsaasBaseUrl()}/customers/${customerId}`
    : `${getAsaasBaseUrl()}/customers`;

  const method = customerId ? 'PUT' : 'POST';

  const response = await fetch(url, {
    method,
    headers: getAsaasHeaders(),
    body: JSON.stringify(customerData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao criar/atualizar cliente Asaas: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Busca um cliente no Asaas por CPF/CNPJ
 */
export async function findAsaasCustomerByCpfCnpj(cpfCnpj: string): Promise<any> {
  const response = await fetch(
    `${getAsaasBaseUrl()}/customers?cpfCnpj=${encodeURIComponent(cpfCnpj)}`,
    {
      method: 'GET',
      headers: getAsaasHeaders(),
    }
  );

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao buscar cliente Asaas: ${JSON.stringify(error)}`);
  }

  const result = await response.json();
  return result.data && result.data.length > 0 ? result.data[0] : null;
}

/**
 * Cria uma assinatura no Asaas
 */
export async function createAsaasSubscription(
  subscriptionData: AsaasSubscriptionData
): Promise<any> {
  const response = await fetch(`${getAsaasBaseUrl()}/subscriptions`, {
    method: 'POST',
    headers: getAsaasHeaders(),
    body: JSON.stringify(subscriptionData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao criar assinatura Asaas: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Cancela uma assinatura no Asaas
 */
export async function cancelAsaasSubscription(subscriptionId: string): Promise<any> {
  const response = await fetch(`${getAsaasBaseUrl()}/subscriptions/${subscriptionId}`, {
    method: 'DELETE',
    headers: getAsaasHeaders(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao cancelar assinatura Asaas: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Busca detalhes de uma assinatura no Asaas
 */
export async function getAsaasSubscription(subscriptionId: string): Promise<any> {
  const response = await fetch(`${getAsaasBaseUrl()}/subscriptions/${subscriptionId}`, {
    method: 'GET',
    headers: getAsaasHeaders(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao buscar assinatura Asaas: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Busca detalhes de um pagamento no Asaas
 */
export async function getAsaasPayment(paymentId: string): Promise<any> {
  const response = await fetch(`${getAsaasBaseUrl()}/payments/${paymentId}`, {
    method: 'GET',
    headers: getAsaasHeaders(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao buscar pagamento Asaas: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Gera o QR Code PIX para um pagamento
 */
export async function getAsaasPixQrCode(paymentId: string): Promise<any> {
  const response = await fetch(`${getAsaasBaseUrl()}/payments/${paymentId}/pixQrCode`, {
    method: 'GET',
    headers: getAsaasHeaders(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao buscar QR Code PIX: ${JSON.stringify(error)}`);
  }

  return await response.json();
}

/**
 * Calcula a próxima data de vencimento (7 dias a partir de hoje)
 */
export function getNextDueDate(daysFromNow: number = 7): string {
  const date = new Date();
  date.setDate(date.getDate() + daysFromNow);
  return date.toISOString().split('T')[0];
}

/**
 * Calcula a data de fim do período de assinatura
 */
export function getNextPeriodEnd(cycle: 'monthly' | 'yearly'): Date {
  const date = new Date();
  if (cycle === 'yearly') {
    date.setFullYear(date.getFullYear() + 1);
  } else {
    date.setMonth(date.getMonth() + 1);
  }
  return date;
}

/**
 * Converte billing cycle do app para formato Asaas
 */
export function convertBillingCycleToAsaas(cycle: 'monthly' | 'yearly'): 'MONTHLY' | 'YEARLY' {
  return cycle === 'yearly' ? 'YEARLY' : 'MONTHLY';
}

/**
 * Converte payment method do app para formato Asaas
 */
export function convertPaymentMethodToAsaas(
  method: 'pix' | 'boleto' | 'credit_card' | 'undefined'
): 'PIX' | 'BOLETO' | 'CREDIT_CARD' | 'UNDEFINED' {
  const map: Record<string, 'PIX' | 'BOLETO' | 'CREDIT_CARD' | 'UNDEFINED'> = {
    pix: 'PIX',
    boleto: 'BOLETO',
    credit_card: 'CREDIT_CARD',
    undefined: 'UNDEFINED',
  };
  return map[method] || 'UNDEFINED';
}

/**
 * Limpa CPF/CNPJ removendo caracteres especiais
 */
export function cleanCpfCnpj(cpfCnpj: string): string {
  return cpfCnpj.replace(/[^\d]/g, '');
}
