import React from 'react';
import { useForm } from 'react-hook-form';
import { Button, Form } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faTrashAlt } from '@fortawesome/free-regular-svg-icons';
import { useParams } from 'react-router-dom';
import useDeleteSharedAccess from '../../hooks/mutations/rooms/useDeleteSharedAccess';

export default function DeleteSharedAccessForm({userId}) {
  const { register, handleSubmit } = useForm();
  const { friendlyId } = useParams();
  const { onSubmit } = useDeleteSharedAccess(friendlyId);

  return (
    <Form onSubmit={handleSubmit(onSubmit)} className="float-end pe-2">
      <input value={userId} {...register('user_id')} />
      <Button variant="font-awesome" type="submit">
        <FontAwesomeIcon icon={faTrashAlt} />
      </Button>
    </Form>
  );
}
