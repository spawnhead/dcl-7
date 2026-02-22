import axios from 'axios'

export type ContractorFilter = {
  ctrName?: string
  ctrFullName?: string
  ctrEmail?: string
  ctrUnp?: string
  page: number
  pageSize: number
}

export type Contractor = {
  ctrId: string
  ctrName: string
  ctrFullName: string
  ctrAddress: string
  ctrPhone: string
  ctrFax: string
  ctrEmail: string
  ctrBankProps: string
  ctrBlock: string
  occupied: boolean
}

export type ContractorUserRow = {
  userId: number
  userFullName: string
}

export type ContractorAccountRow = {
  accName: string
  accAccount: string
  currencyId: number | null
  accIndex: number
  isDefault: boolean
}

export type ContractorContactPersonRow = {
  cpsName: string
  cpsPhone: string
  cpsFax: string
  cpsEmail: string
  cpsPosition: string
  cpsBlock: number
  cpsFire: number
}

export type ContractorPermissions = {
  canCreate: boolean
  canEdit: boolean
  canBlock: boolean
  canDelete: boolean
}

export type ContractorLookups = {
  permissions: ContractorPermissions
}

export type ContractorPage = {
  items: Contractor[]
  page: number
  pageSize: number
  hasNextPage: boolean
}

export type ContractorForm = {
  ctrId: number | null
  returnTo: string
  ctrName: string
  ctrFullName: string
  ctrEmail: string
  ctrUnp: string
  ctrPhone: string
  ctrFax: string
  ctrBankProps: string
  ctrIndex: string
  ctrRegion: string
  ctrPlace: string
  ctrStreet: string
  ctrBuilding: string
  ctrAddInfo: string
  countryId: number
  reputationId: number
  currencyId: number
  ctrBlock: number
  activeTab: string
  isNewDoc: boolean
  users: ContractorUserRow[]
  accounts: ContractorAccountRow[]
  contactPersons: ContractorContactPersonRow[]
}

export type ContractorSavePayload = {
  returnTo: string
  ctrName: string
  ctrFullName: string
  ctrEmail: string
  ctrUnp: string
  ctrPhone: string
  ctrFax: string
  ctrBankProps: string
  ctrIndex: string
  ctrRegion: string
  ctrPlace: string
  ctrStreet: string
  ctrBuilding: string
  ctrAddInfo: string
  countryId: number
  reputationId: number
  currencyId: number
  ctrBlock: number
  activeTab: string
  users: ContractorUserRow[]
  accounts: ContractorAccountRow[]
  contactPersons: ContractorContactPersonRow[]
}

export type ContractorSaveResult = {
  ctrId: number
  returnTo: string
  redirectTo: string
  message: string
}

const api = axios.create({ baseURL: '/api' })

export async function fetchContractors(payload: ContractorFilter): Promise<ContractorPage> {
  const { data } = await api.post<ContractorPage>('/contractors/data', payload)
  return data
}

export async function openContractorCreate(returnTo = 'contractors'): Promise<ContractorForm> {
  const { data } = await api.get<ContractorForm>('/contractors/create/open', { params: { returnTo } })
  return data
}

export async function openContractorEdit(ctrId: string): Promise<ContractorForm> {
  const { data } = await api.get<ContractorForm>(`/contractors/${ctrId}/edit/open`)
  return data
}

export async function saveContractorCreate(payload: ContractorSavePayload): Promise<ContractorSaveResult> {
  const { data } = await api.post<ContractorSaveResult>('/contractors/create/save', payload)
  return data
}

export async function saveContractorEdit(
  ctrId: string,
  payload: ContractorSavePayload,
): Promise<ContractorSaveResult> {
  const { data } = await api.put<ContractorSaveResult>(`/contractors/${ctrId}/edit/save`, payload)
  return data
}

export async function blockContractor(ctrId: number, block: 0 | 1, role: string) {
  await api.post('/contractors/block', { ctrId, block }, { headers: { 'X-Role': role } })
}

export async function deleteContractor(ctrId: number, role: string) {
  await api.delete(`/contractors/${ctrId}`, { headers: { 'X-Role': role } })
}

export async function fetchContractorLookups(role: string): Promise<ContractorLookups> {
  const { data } = await api.get<ContractorLookups>('/contractors/lookups', {
    headers: { 'X-Role': role },
  })
  return data
}
