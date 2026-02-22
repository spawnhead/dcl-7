import React, { useState } from 'react';
import { Upload, List, Typography, Button } from 'antd';
import { InboxOutlined, FileOutlined, DeleteOutlined } from '@ant-design/icons';
import type { UploadProps } from 'antd';

const { Dragger } = Upload;
const { Text } = Typography;

export function FileUploadSection() {
  const [fileList, setFileList] = useState<any[]>([]);

  const props: UploadProps = {
    name: 'file',
    multiple: true,
    fileList: fileList,
    beforeUpload: (file) => {
      setFileList([...fileList, file]);
      return false; // Prevent auto upload
    },
    onRemove: (file) => {
      const index = fileList.indexOf(file);
      const newFileList = fileList.slice();
      newFileList.splice(index, 1);
      setFileList(newFileList);
    },
    showUploadList: false,
  };

  return (
    <div>
      <Dragger {...props} style={{ marginBottom: fileList.length > 0 ? 16 : 0 }}>
        <p className="ant-upload-drag-icon">
          <InboxOutlined style={{ fontSize: 48, color: '#1677ff' }} />
        </p>
        <p className="ant-upload-text" style={{ fontSize: 14 }}>
          Перетащите файлы сюда или нажмите для выбора
        </p>
        <p className="ant-upload-hint" style={{ fontSize: 12 }}>
          Поддерживаются PDF, DOC, DOCX, XLS, XLSX, JPG, PNG (макс. 10 МБ)
        </p>
      </Dragger>

      {fileList.length > 0 && (
        <List
          dataSource={fileList}
          renderItem={(file, index) => (
            <List.Item
              key={index}
              actions={[
                <Button
                  type="text"
                  danger
                  icon={<DeleteOutlined />}
                  onClick={() => {
                    const newFileList = fileList.filter((_, i) => i !== index);
                    setFileList(newFileList);
                  }}
                />,
              ]}
            >
              <List.Item.Meta
                avatar={<FileOutlined style={{ fontSize: 20, color: '#8c8c8c' }} />}
                title={file.name}
                description={`${(file.size / 1024).toFixed(2)} KB`}
              />
            </List.Item>
          )}
          bordered
        />
      )}
    </div>
  );
}
