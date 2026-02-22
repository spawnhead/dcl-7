import axios from 'axios'

export type Currency = {
  id: number
  name: string
  noRound: number | null
  sortOrder: number | null
}

const api = axios.create({ baseURL: '/api' })

export async function fetchCurrencies() {
  const { data } = await api.get<Currency[]>('/currencies')
  return data
}

export async function createCurrency(payload: {
  name: string
  noRound: number | null
  sortOrder: number | null
}) {
  const { data } = await api.post<Currency>('/currencies', payload)
  return data
}

export async function updateCurrency(
  id: number,
  payload: { name: string; noRound: number | null; sortOrder: number | null },
) {
  const { data } = await api.put<Currency>(`/currencies/${id}`, payload)
  return data
}

export async function deleteCurrency(id: number) {
  await api.delete(`/currencies/${id}`)
}
