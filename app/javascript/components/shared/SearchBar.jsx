import React from 'react';
import { Form } from 'react-bootstrap';

export default function SearchBar({ id, setSearch }) {
  return (
    <Form>
      <Form.Group>
        <Form.Control
          id={id}
          className="rounded border"
          placeholder="Search"
          type="search"
          onKeyPress={(e) => (
            e.key === 'Enter' && e.preventDefault()
          )}
          onChange={(event) => setSearch(event.target.value)}
        />
      </Form.Group>
    </Form>
  );
}
