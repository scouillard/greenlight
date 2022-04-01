import React from 'react';
import { useMutation, useQueryClient } from 'react-query';
import { useNavigate } from 'react-router-dom';
import axios, { ENDPOINTS } from '../../../helpers/Axios';

const createSession = (sessionUser) => axios.post(ENDPOINTS.sign_in, sessionUser)
  .then((resp) => resp.data)
  .catch((error) => console.log(error));

export default function usePostSession() {
  const queryClient = useQueryClient();
  const navigate = useNavigate();

  return useMutation(createSession, {
    // Re-fetch the current_user and redirect to homepage if Mutation is successful.
    onSuccess: () => {
      queryClient.invalidateQueries('currentUser');
      navigate('/rooms');
    },
    onError: (error) => {
      console.log('mutate error', error);
    },
  });
}
