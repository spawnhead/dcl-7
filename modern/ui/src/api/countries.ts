import axios from 'axios'

export type Country = {
  id: number
  name: string
  createDate: string
  createUserId: number
  editDate: string
  editUserId: number
}

const api = axios.create({ baseURL: '/api' })

export async function fetchCountries() {
  const { data } = await api.get<Country[]>('/countries')
  return data
}

export async function createCountry(name: string) {
  const { data } = await api.post<Country>('/countries', { name })
  return data
}

export async function updateCountry(id: number, name: string) {
  const { data } = await api.put<Country>(`/countries/${id}`, { name })
  return data
}

export async function deleteCountry(id: number) {
  await api.delete(`/countries/${id}`)
}
