import React from 'react';

interface SectionHeaderProps {
  title: string;
  description?: string;
  compact?: boolean;
}

export function SectionHeader({ title, description, compact = false }: SectionHeaderProps) {
  return (
    <div className={compact ? 'space-y-0.5' : 'space-y-1'}>
      <h2 className={`font-semibold text-slate-900 ${compact ? 'text-base' : 'text-lg'}`}>
        {title}
      </h2>
      {description && (
        <p className="text-sm text-slate-500">
          {description}
        </p>
      )}
    </div>
  );
}
