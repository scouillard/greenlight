import React, { useState } from 'react';
import { Button, Col, Form, Row, Stack } from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import { useParams } from 'react-router-dom';
import useShareAccess from '../../hooks/mutations/rooms/useShareAccess';
import Avatar from '../users/Avatar';
import SearchBar from '../shared/SearchBar';
import useShareableUsers from '../../hooks/queries/rooms/useShareableUsers';

export default function SharedAccessForm({ handleClose }) {
  const { register, handleSubmit } = useForm();
  const { friendlyId } = useParams();
  const { onSubmit } = useShareAccess({ friendlyId, closeModal: handleClose });
  const { data: users } = useShareableUsers(friendlyId);
  const [search, setSearch] = useState('');

  return (
    <>
      <SearchBar id="shared-users-modal-search" setSearch={setSearch} />
      <Form onSubmit={handleSubmit(onSubmit)}>
        <Row className="border-bottom pt-3 pb-2">
          <Col>
            <span className="text-muted small"> Name </span>
          </Col>
          <Col>
            <span className="text-muted small"> Email address </span>
          </Col>
        </Row>
        {
          users?.filter((user) => {
            if (user.name.toLowerCase().includes(search.toLowerCase())) {
              return user;
            }
            return false;
          }).map((user) => (
            <Row className="border-bottom py-3" key={user.id}>
              <Col>
                <Stack direction="horizontal">
                  <Form.Check
                    type="checkbox"
                    value={user.id}
                    aria-label="tbd"
                    className="pe-3"
                    {...register('shared_access_users')}
                  />
                  <Avatar avatar={user.avatar} radius={40} />
                  <h6 className="text-primary mb-0 ps-3"> { user.name } </h6>
                </Stack>
              </Col>
              <Col className="my-auto">
                <span className="text-muted"> { user.email } </span>
              </Col>
            </Row>
          ))
        }
        <Stack className="mt-3" direction="horizontal" gap={1}>
          <Button variant="primary-reverse" className="ms-auto" onClick={handleClose}>
            Close
          </Button>
          <Button variant="primary" type="submit">
            Share
          </Button>
        </Stack>
      </Form>
    </>
  );
}
