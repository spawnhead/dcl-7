import React from 'react';
import { Label } from './ui/label';

interface FormFieldProps {
  label: string;
  required?: boolean;
  helperText?: string;
  children: React.ReactNode;
}

export function FormField({ label, required, helperText, children }: FormFieldProps) {
  return (
    <div className="space-y-2">
      <Label className="text-sm font-medium text-slate-700">
        {label}
        {required && <span className="text-red-500 ml-1">*</span>}
      </Label>
      {children}
      {helperText && (
        <p className="text-xs text-slate-500">
          {helperText}
        </p>
      )}
    </div>
  );
}
