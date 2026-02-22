import React from 'react';
import { ConfigProvider, theme, Breadcrumb } from 'antd';
import { HomeOutlined } from '@ant-design/icons';
import { ContractForm } from './components/ContractForm';
import ruRU from 'antd/locale/ru_RU';
import 'antd/dist/reset.css';

export default function App() {
  return (
    <ConfigProvider
      locale={ruRU}
      theme={{
        token: {
          colorPrimary: '#1677ff',
          borderRadius: 6,
          fontSize: 14,
        },
        algorithm: theme.defaultAlgorithm,
      }}
    >
      <div className="min-h-screen bg-slate-50">
        {/* Header */}
        <header className="bg-white border-b border-slate-200 sticky top-0 z-10 shadow-sm">
          <div className="max-w-[1440px] mx-auto px-6 py-4">
            <Breadcrumb
              items={[
                {
                  href: '/',
                  title: (
                    <>
                      <HomeOutlined />
                      <span>Главная</span>
                    </>
                  ),
                },
                {
                  href: '/contracts',
                  title: 'Договоры',
                },
                {
                  title: 'Создание договора',
                },
              ]}
            />
            
            <h1 className="text-2xl font-semibold text-slate-900 mt-3 mb-0">
              Создание договора
            </h1>
          </div>
        </header>

        {/* Main Content */}
        <main className="max-w-[1440px] mx-auto px-6 py-6">
          <ContractForm />
        </main>
      </div>
    </ConfigProvider>
  );
}
