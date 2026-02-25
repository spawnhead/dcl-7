import axios from 'axios'

import type { Session } from '../auth/session'

const api = axios.create({ baseURL: '/api' })

export async function login(username: string, password: string): Promise<Session> {
  const { data } = await api.post<Session>('/auth/login', { username, password })
  return data
}
