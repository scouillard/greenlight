import React from 'react';
import { Form as BootStrapForm } from 'react-bootstrap';
import { useFormContext } from 'react-hook-form';

export function FormControl({ field, ...props }) {
  const { register, formState: { errors } } = useFormContext();
  const { hookForm } = field;
  const { id, validations } = hookForm;
  const error = errors[id];
  return (
    <BootStrapForm.Group className="mb-2" controlId={field.controlId}>
      <BootStrapForm.Label className="small mb-0">
        {field.label}
      </BootStrapForm.Label>
      <BootStrapForm.Control {...props} placeholder={field.placeHolder} isInvalid={error} {...register(id, validations)} />
      {
              error
              && (
                (error.types
                  && Object.keys(error.types).map(
                    (key) => <BootStrapForm.Control.Feedback key={key} type="invalid">{error.types[key]}</BootStrapForm.Control.Feedback>,
                  )
                )
                || <BootStrapForm.Control.Feedback type="invalid">{error.message}</BootStrapForm.Control.Feedback>
              )

          }
    </BootStrapForm.Group>
  );
}
