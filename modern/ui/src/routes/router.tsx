import {
  Outlet,
  RouterProvider,
  createRootRoute,
  createRoute,
  createRouter,
  redirect,
} from '@tanstack/react-router'

import { loadSession } from '../auth/session'
import { ContractorFormPage } from '../components/ContractorFormPage'
import { ContractorsPanel } from '../components/ContractorsPanel'
import { CountriesPanel } from '../components/CountriesPanel'
import { CurrenciesPanel } from '../components/CurrenciesPanel'
import { LoginPage } from './LoginPage'
import { ReferencesLayout } from './ReferencesLayout'

const rootRoute = createRootRoute({ component: () => <Outlet /> })

const loginRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/login',
  component: LoginPage,
})

const referencesRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/references',
  beforeLoad: () => {
    if (!loadSession()) {
      throw redirect({ to: '/login' })
    }
  },
  component: ReferencesLayout,
})

const countriesRoute = createRoute({
  getParentRoute: () => referencesRoute,
  path: '/countries',
  component: CountriesPanel,
})

const currenciesRoute = createRoute({
  getParentRoute: () => referencesRoute,
  path: '/currencies',
  component: CurrenciesPanel,
})

const contractorsRoute = createRoute({
  getParentRoute: () => referencesRoute,
  path: '/contractors',
  component: ContractorsPanel,
})

const contractorsCreateRoute = createRoute({
  getParentRoute: () => referencesRoute,
  path: '/contractors/new',
  component: ContractorFormPage,
})

const contractorsEditRoute = createRoute({
  getParentRoute: () => referencesRoute,
  path: '/contractors/$ctrId/edit',
  component: ContractorFormPage,
})

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  beforeLoad: () => {
    if (loadSession()) {
      throw redirect({ to: '/references/countries' })
    }
    throw redirect({ to: '/login' })
  },
})

const routeTree = rootRoute.addChildren([
  indexRoute,
  loginRoute,
  referencesRoute.addChildren([
    countriesRoute,
    currenciesRoute,
    contractorsRoute,
    contractorsCreateRoute,
    contractorsEditRoute,
  ]),
])

const router = createRouter({ routeTree })

export function AppRouter() {
  return <RouterProvider router={router} />
}
