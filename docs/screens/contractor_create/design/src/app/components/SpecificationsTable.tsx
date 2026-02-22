import React from 'react';
import { Table, Empty } from 'antd';
import { FileTextOutlined } from '@ant-design/icons';
import type { ColumnsType } from 'antd/es/table';

interface SpecificationType {
  key: string;
  number: string;
  date: string;
  amount: number;
  vatPercent: number;
  amountWithVat: number;
  balance: number;
  note: string;
}

const columns: ColumnsType<SpecificationType> = [
  {
    title: 'Номер',
    dataIndex: 'number',
    key: 'number',
    width: 120,
  },
  {
    title: 'Дата',
    dataIndex: 'date',
    key: 'date',
    width: 120,
  },
  {
    title: 'Сумма',
    dataIndex: 'amount',
    key: 'amount',
    align: 'right',
    width: 130,
    render: (value) => value?.toLocaleString('ru-RU', { minimumFractionDigits: 2 }),
  },
  {
    title: 'НДС %',
    dataIndex: 'vatPercent',
    key: 'vatPercent',
    align: 'right',
    width: 100,
  },
  {
    title: 'Сумма с НДС',
    dataIndex: 'amountWithVat',
    key: 'amountWithVat',
    align: 'right',
    width: 150,
    render: (value) => value?.toLocaleString('ru-RU', { minimumFractionDigits: 2 }),
  },
  {
    title: 'Остаток',
    dataIndex: 'balance',
    key: 'balance',
    align: 'right',
    width: 130,
    render: (value) => value?.toLocaleString('ru-RU', { minimumFractionDigits: 2 }),
  },
  {
    title: 'Примечание',
    dataIndex: 'note',
    key: 'note',
    ellipsis: true,
  },
];

export function SpecificationsTable() {
  const data: SpecificationType[] = [];

  return (
    <Table
      columns={columns}
      dataSource={data}
      pagination={false}
      bordered
      locale={{
        emptyText: (
          <Empty
            image={<FileTextOutlined style={{ fontSize: 48, color: '#bfbfbf' }} />}
            description={
              <div>
                <div>Нет спецификаций</div>
                <div style={{ fontSize: 12, color: '#8c8c8c', marginTop: 4 }}>
                  Нажмите "Создать спецификацию" чтобы добавить
                </div>
              </div>
            }
          />
        ),
      }}
    />
  );
}
