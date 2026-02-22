import { FormEvent, useEffect, useMemo, useState } from 'react'
import { useNavigate, useParams } from '@tanstack/react-router'

import {
  openContractorCreate,
  openContractorEdit,
  saveContractorCreate,
  saveContractorEdit,
  type ContractorForm,
} from '../api/contractors'

type TabKey =
  | 'mainPanel'
  | 'usersContractor'
  | 'accountsContractor'
  | 'contactPersonsContractor'
  | 'commentContractor'

type AccountRow = {
  id: string
  account: string
  currencyId: string
  isDefault: boolean
}

const tabs: Array<{ key: TabKey; label: string }> = [
  { key: 'mainPanel', label: 'Главная' },
  { key: 'usersContractor', label: 'Курируют' },
  { key: 'accountsContractor', label: 'Расчетные счета и банковские реквизиты' },
  { key: 'contactPersonsContractor', label: 'Контактные лица' },
  { key: 'commentContractor', label: 'Комментарии' },
]

const defaultAccounts: AccountRow[] = [
  { id: 'd1', account: '', currencyId: '', isDefault: true },
  { id: 'd2', account: '', currencyId: '', isDefault: true },
  { id: 'd3', account: '', currencyId: '', isDefault: true },
]

const defaultForm: ContractorForm = {
  ctrId: null,
  returnTo: 'contractors',
  ctrName: '',
  ctrFullName: '',
  ctrEmail: '',
  ctrUnp: '',
  ctrPhone: '',
  ctrFax: '',
  ctrBankProps: '',
  ctrIndex: '',
  ctrRegion: '',
  ctrPlace: '',
  ctrStreet: '',
  ctrBuilding: '',
  ctrAddInfo: '',
  countryId: 1,
  reputationId: 1,
  currencyId: 1,
  ctrBlock: 0,
  activeTab: 'mainPanel',
  isNewDoc: true,
}

export function ContractorFormPage() {
  const navigate = useNavigate()
  const params = useParams({ strict: false }) as { ctrId?: string }
  const ctrId = params?.ctrId
  const isEdit = Boolean(ctrId)

  const [form, setForm] = useState<ContractorForm>(defaultForm)
  const [activeTab, setActiveTab] = useState<TabKey>('mainPanel')
  const [accounts, setAccounts] = useState<AccountRow[]>(defaultAccounts)
  const [users, setUsers] = useState<string[]>(['Текущий пользователь'])
  const [contactPersons, setContactPersons] = useState<string[]>([])
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const [tabErrors, setTabErrors] = useState<Partial<Record<TabKey, string>>>({})

  useEffect(() => {
    const load = async () => {
      try {
        const data = isEdit ? await openContractorEdit(String(ctrId)) : await openContractorCreate('contractors')
        setForm(data)
        setActiveTab((data.activeTab as TabKey) ?? 'mainPanel')
      } catch {
        setError('Не удалось загрузить форму контрагента')
      }
    }
    void load()
  }, [ctrId, isEdit])

  const address = useMemo(() => {
    return [form.ctrIndex, form.ctrRegion, form.ctrPlace, form.ctrStreet, form.ctrBuilding, form.ctrAddInfo]
      .filter((x) => x && x.trim())
      .join(', ')
  }, [form.ctrAddInfo, form.ctrBuilding, form.ctrIndex, form.ctrPlace, form.ctrRegion, form.ctrStreet])

  const validate = () => {
    const next: Partial<Record<TabKey, string>> = {}

    if (!form.ctrName.trim() || !form.ctrFullName.trim()) {
      next.mainPanel = 'Заполните обязательные поля на вкладке «Главная»'
    }

    if (form.ctrUnp.trim() && (form.ctrUnp.trim().length < 6 || form.ctrUnp.trim().length > 15)) {
      next.mainPanel = 'УНП должен быть от 6 до 15 символов'
    }

    const hasAccountError = accounts.some((row) => {
      const hasAccount = row.account.trim().length > 0
      const hasCurrency = row.currencyId.trim().length > 0
      if (row.isDefault) {
        return hasAccount && !hasCurrency
      }
      return hasAccount !== hasCurrency
    })

    if (hasAccountError) {
      next.accountsContractor =
        'Проверьте расчетные счета: для default-строки при заполненном счете нужна валюта, для custom-строки оба поля обязательны'
    }

    setTabErrors(next)
    const firstErrorTab = tabs.find((tab) => next[tab.key])?.key
    if (firstErrorTab) {
      setActiveTab(firstErrorTab)
      setError(next[firstErrorTab] ?? 'Ошибка валидации')
      return false
    }

    return true
  }

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!validate()) {
      return
    }

    const payload = {
      returnTo: form.returnTo,
      ctrName: form.ctrName,
      ctrFullName: form.ctrFullName,
      ctrEmail: form.ctrEmail,
      ctrUnp: form.ctrUnp,
      ctrPhone: form.ctrPhone,
      ctrFax: form.ctrFax,
      ctrBankProps: form.ctrBankProps,
      ctrIndex: form.ctrIndex,
      ctrRegion: form.ctrRegion,
      ctrPlace: form.ctrPlace,
      ctrStreet: form.ctrStreet,
      ctrBuilding: form.ctrBuilding,
      ctrAddInfo: form.ctrAddInfo,
      countryId: form.countryId,
      reputationId: form.reputationId,
      currencyId: form.currencyId,
      ctrBlock: form.ctrBlock,
      activeTab,
    }

    try {
      const result = isEdit
        ? await saveContractorEdit(String(ctrId), payload)
        : await saveContractorCreate(payload)
      setSuccess(result.message)
      await navigate({ to: '/references/contractors' })
    } catch {
      setError('Ошибка сохранения контрагента')
    }
  }

  return (
    <section>
      <h2 className="mb-4 text-2xl font-semibold">
        {isEdit ? 'Редактировать контрагента' : 'Создать контрагента'}
      </h2>

      <div className="mb-4 flex flex-wrap gap-2">
        {tabs.map((tab) => (
          <button
            key={tab.key}
            type="button"
            className={`rounded border px-3 py-2 text-sm ${activeTab === tab.key ? 'bg-slate-900 text-white' : ''}`}
            onClick={() => setActiveTab(tab.key)}
          >
            {tab.label}
            {tabErrors[tab.key] ? ' •' : ''}
          </button>
        ))}
      </div>

      <form onSubmit={onSubmit} className="space-y-4">
        {activeTab === 'mainPanel' && (
          <div className="grid grid-cols-2 gap-3">
            <input className="rounded border px-3 py-2" placeholder="Наименование*" value={form.ctrName} onChange={(e) => setForm((f) => ({ ...f, ctrName: e.target.value }))} maxLength={200} required />
            <input className="rounded border px-3 py-2" placeholder="Полное наименование*" value={form.ctrFullName} onChange={(e) => setForm((f) => ({ ...f, ctrFullName: e.target.value }))} maxLength={300} required />
            <input className="rounded border px-3 py-2" placeholder="Email" value={form.ctrEmail} onChange={(e) => setForm((f) => ({ ...f, ctrEmail: e.target.value }))} maxLength={40} />
            <input className="rounded border px-3 py-2" placeholder="УНП" value={form.ctrUnp} onChange={(e) => setForm((f) => ({ ...f, ctrUnp: e.target.value }))} maxLength={15} />
            <input className="rounded border px-3 py-2" placeholder="Телефон" value={form.ctrPhone} onChange={(e) => setForm((f) => ({ ...f, ctrPhone: e.target.value }))} maxLength={100} />
            <input className="rounded border px-3 py-2" placeholder="Факс" value={form.ctrFax} onChange={(e) => setForm((f) => ({ ...f, ctrFax: e.target.value }))} maxLength={100} />
            <input className="rounded border px-3 py-2" placeholder="Индекс" value={form.ctrIndex} onChange={(e) => setForm((f) => ({ ...f, ctrIndex: e.target.value }))} maxLength={20} />
            <input className="rounded border px-3 py-2" placeholder="Регион" value={form.ctrRegion} onChange={(e) => setForm((f) => ({ ...f, ctrRegion: e.target.value }))} maxLength={50} />
            <input className="rounded border px-3 py-2" placeholder="Нас.пункт" value={form.ctrPlace} onChange={(e) => setForm((f) => ({ ...f, ctrPlace: e.target.value }))} maxLength={50} />
            <input className="rounded border px-3 py-2" placeholder="Улица" value={form.ctrStreet} onChange={(e) => setForm((f) => ({ ...f, ctrStreet: e.target.value }))} maxLength={50} />
            <input className="rounded border px-3 py-2" placeholder="Дом" value={form.ctrBuilding} onChange={(e) => setForm((f) => ({ ...f, ctrBuilding: e.target.value }))} maxLength={10} />
            <input className="rounded border px-3 py-2" placeholder="Доп. инфо" value={form.ctrAddInfo} onChange={(e) => setForm((f) => ({ ...f, ctrAddInfo: e.target.value }))} maxLength={1000} />
            <input className="col-span-2 rounded border bg-slate-50 px-3 py-2" placeholder="Адрес (вычисляемый)" value={address} readOnly />
          </div>
        )}

        {activeTab === 'usersContractor' && (
          <div className="space-y-2">
            <p className="text-sm text-slate-600">Курируют (baseline)</p>
            {users.map((user, index) => (
              <div key={`${user}-${index}`} className="rounded border px-3 py-2">{user}</div>
            ))}
            <button type="button" className="rounded border px-3 py-2" onClick={() => setUsers((u) => [...u, `Пользователь ${u.length + 1}`])}>Добавить пользователя</button>
          </div>
        )}

        {activeTab === 'accountsContractor' && (
          <div className="space-y-2">
            <p className="text-sm text-slate-600">Счета: первые 3 строки — default, далее custom.</p>
            {accounts.map((row, index) => (
              <div key={row.id} className="grid grid-cols-5 gap-2">
                <input className="col-span-3 rounded border px-3 py-2" placeholder={`Счет #${index + 1}`} value={row.account} maxLength={35} onChange={(e) => setAccounts((all) => all.map((it) => (it.id === row.id ? { ...it, account: e.target.value } : it)))} />
                <input className="rounded border px-3 py-2" placeholder="Currency ID" value={row.currencyId} onChange={(e) => setAccounts((all) => all.map((it) => (it.id === row.id ? { ...it, currencyId: e.target.value } : it)))} />
                <button type="button" className="rounded border px-3 py-2" disabled={row.isDefault} onClick={() => setAccounts((all) => all.filter((it) => it.id !== row.id))}>Удалить</button>
              </div>
            ))}
            <button type="button" className="rounded border px-3 py-2" onClick={() => setAccounts((all) => [...all, { id: `c${Date.now()}`, account: '', currencyId: '', isDefault: false }])}>Добавить счет</button>
          </div>
        )}

        {activeTab === 'contactPersonsContractor' && (
          <div className="space-y-2">
            <p className="text-sm text-slate-600">Контактные лица (baseline)</p>
            {contactPersons.length === 0 ? (
              <div className="rounded border border-dashed p-3 text-sm text-slate-500">Нет контактных лиц</div>
            ) : (
              contactPersons.map((person, index) => (
                <div key={`${person}-${index}`} className="rounded border px-3 py-2">{person}</div>
              ))
            )}
            <button type="button" className="rounded border px-3 py-2" onClick={() => setContactPersons((p) => [...p, `Контакт ${p.length + 1}`])}>Добавить контакт</button>
          </div>
        )}

        {activeTab === 'commentContractor' && (
          <textarea className="w-full rounded border px-3 py-2" rows={6} maxLength={800} placeholder="Комментарий / банковские реквизиты" value={form.ctrBankProps} onChange={(e) => setForm((f) => ({ ...f, ctrBankProps: e.target.value }))} />
        )}

        <div className="flex gap-2">
          <button type="submit" className="rounded bg-slate-900 px-4 py-2 text-white">Сохранить</button>
          <button type="button" className="rounded border px-4 py-2" onClick={() => void navigate({ to: '/references/contractors' })}>Отмена</button>
        </div>
      </form>

      {error && <div className="mt-3 rounded bg-red-100 p-2 text-red-700">{error}</div>}
      {success && <div className="mt-3 rounded bg-green-100 p-2 text-green-700">{success}</div>}
    </section>
  )
}
